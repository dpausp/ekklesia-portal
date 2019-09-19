import argparse
import json
import logging
from eliot import log_call, start_task

import sqlalchemy.orm
import transaction
from case_conversion import case_conversion


@log_call
def load_proposition_json_file(filepath):
    with open(filepath) as f:
        json_data = json.load(f)

    required_fields = {
        'title',
        'author',
        'abstract',
        'content'
    }

    optional_fields = {
        'motivation',
        'tags',
        'external_discussion_url'
    }

    missing_fields = required_fields - set(json_data)

    if missing_fields:
        raise Exception(f"JSON: missing fields: {missing_fields}")

    imported = {}

    for key in required_fields:
        imported[key] = json_data[key]

    imported["author"] = case_conversion.dashcase(imported["author"])[:64]

    for key in optional_fields:
        imported[key] = json_data.get(key)

    if "tags" not in imported:
        imported["tags"] = []

    if "type" in json_data:
        imported["tags"].append(json_data["type"])

    if "group" in json_data:
        imported["tags"].append(json_data["group"])

    imported["tags"] = list(set(case_conversion.dashcase(tag) for tag in imported["tags"]))

    return imported


@log_call
def insert_proposition(department_name, title, abstract, content, motivation, author, tags, external_discussion_url):
    department = session.query(Department).filter_by(name=department_name).one()
    maybe_subject_area = [area for area in department.areas if area.name == "Allgemein"]

    if not maybe_subject_area:
        raise ValueError("Subject area 'Allgemein' not found! Please create it!")

    subject_area = maybe_subject_area[0]
    # TODO: Adding support for multiple proposition submitters
    user = session.query(User).filter_by(name=author).scalar()

    if user is None:
        user = User(name=author, auth_type="import")

    ballot = Ballot(area=subject_area)
    proposition = Proposition(title=title, abstract=abstract, content=content, motivation=motivation,
                              external_discussion_url=external_discussion_url, ballot=ballot)

    for tag_name in tags:
        tag = session.query(Tag).filter_by(name=tag_name).scalar()
        if tag is None:
            tag = Tag(name=tag_name)
        proposition.tags.append(tag)

    supporter = Supporter(member=user, proposition=proposition, submitter=True)
    session.add(supporter)


parser = argparse.ArgumentParser("Ekklesia Portal import_proposition_json.py")
parser.add_argument("-c", "--config-file", help=f"path to config file in YAML / JSON format")
parser.add_argument("-d", "--department", help=f"Choose the department to import to.")
parser.add_argument('filenames', nargs='+')

if __name__ == "__main__":

    logg = logging.getLogger(__name__)

    args = parser.parse_args()

    from ekklesia_portal.app import make_wsgi_app

    app = make_wsgi_app(args.config_file)

    from ekklesia_portal.database.datamodel import Ballot, Department, Proposition, User, Supporter, Tag
    from ekklesia_portal.database import Session

    session = Session()

    sqlalchemy.orm.configure_mappers()

    for fp in args.filenames:
        with start_task(action_type="import_proposition"):
            imported_data = load_proposition_json_file(fp)
            insert_proposition(args.department, **imported_data)

    transaction.commit()
