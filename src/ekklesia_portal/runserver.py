import argparse
import datetime
import glob
import os
import os.path
import sys
import tempfile

import werkzeug.serving
from werkzeug.middleware.shared_data import SharedDataMiddleware

tmpdir = tempfile.gettempdir()
parser = argparse.ArgumentParser("Ekklesia Portal runserver.py")

parser.add_argument(
    "-b", "--bind", default="localhost", help="hostname / IP to bind to, default ekklesia-portal-localhost"
)
parser.add_argument("-p", "--http_port", default=8080, type=int, help="HTTP port to use, default 8080")
parser.add_argument("-d", "--debug", action="store_true", help="enable werkzeug debugger / reloader")
parser.add_argument("-s", "--stackdump", action="store_true", help=f"write stackdumps to temp dir {tmpdir} on SIGQUIT")
parser.add_argument("-c", "--config-file", help=f"path to config file in YAML / JSON format")


def stackdump_setup():
    import codecs
    import logging
    import sys
    logg = logging.getLogger(__name__)
    import threading
    import traceback
    try:
        import IPython.core.ultratb as ultratb
    except BaseException:
        ultratb = None

    if ultratb is None:
        logg.warn("IPython not installed, stack dumps not available!")
    else:
        logg.info("IPython installed, write stack dumps to tmpdir with: `kill -QUIT <ekklesia_portal_pid>`")

        def dumpstacks(signal, frame):
            print("dumping stack")
            filepath = os.path.join(tmpdir, "ekklesia_portal_threadstatus")
            id2name = dict([(th.ident, th.name) for th in threading.enumerate()])
            full = ["-" * 80]
            tb_formatter = ultratb.ListTB(color_scheme="Linux")
            for thread_id, stack in sys._current_frames().items():
                thread_name = id2name.get(thread_id, "")
                stacktrace = traceback.extract_stack(stack)
                stb = tb_formatter.structured_traceback(Exception, Exception(), stacktrace)[8:-1]
                if stb:
                    formatted_trace = tb_formatter.stb2text(stb).strip()
                    with codecs.open("{}.{}".format(filepath, thread_id), "w", encoding='utf8') as wf:
                        wf.write("\n{}".format(formatted_trace))
                    if len(stb) > 4:
                        short_stb = stb[:2] + ["..."] + stb[-2:]
                    else:
                        short_stb = stb
                    formatted_trace_short = tb_formatter.stb2text(short_stb).strip()
                    full.append("# Thread: %s(%d)" % (thread_name, thread_id))
                    full.append(formatted_trace_short)
                    full.append("-" * 80)

            with codecs.open(filepath, "w", encoding='utf8') as wf:
                wf.write("\n".join(full))

        import signal
        signal.signal(signal.SIGQUIT, dumpstacks)


def run():
    from ekklesia_portal.app import make_wsgi_app
    args = parser.parse_args()
    wsgi_app = make_wsgi_app(args.config_file)

    wrapped_app = SharedDataMiddleware(
        wsgi_app, {
            '/static': ("ekklesia_portal", 'static'),
            '/static/deform': ("deform", 'static'),
            '/static/webfonts': os.environ.get('WEBFONTS_PATH'),
            '/static/js': os.environ.get('JS_PATH')
        }
    )

    if args.stackdump:
        stackdump_setup()

    if args.debug:
        # use ipdb as default breakpoint() hook (Python 3.7 feature)
        try:
            import ipdb
        except ImportError:
            pass
        else:
            sys.breakpointhook = ipdb.set_trace
    else:
        def breakpoint_in_production(*args, **kwargs):
            pass

        sys.breakpointhook = breakpoint_in_production

    with open(os.path.join(tmpdir, "ekklesia_portal.started"), "w") as wf:
        wf.write(datetime.datetime.now().isoformat())
        wf.write("\n")

    # reload when translation MO files change
    extra_reload_files = glob.glob('src/ekklesia_portal/translations/**/*.mo', recursive=True)
    if args.config_file is not None:
        extra_reload_files.append(args.config_file)

    werkzeug.serving.run_simple(
        args.bind,
        args.http_port,
        wrapped_app,
        use_reloader=args.debug,
        extra_files=extra_reload_files,
        use_debugger=args.debug
    )


if __name__ == "__main__":
    run()
