import secrets


settings = {
    "app": {
        "title": "Ekklesia Portal Dev",
        "fail_on_form_validation_error": False,
        "instance_name": "ekklesia_portal",
        "insecure_development_mode": False,
        "internal_login_enabled": True,
        "custom_footer_url": None,
        "tos_url": None,
        "faq_url": None,
        "imprint_url": None
    },
    "database": {
        "uri": "postgresql+psycopg2://ekklesia_portal:ekklesia_portal@127.0.0.1/ekklesia_portal"
    },
    "browser_session": {
        "secret_key": secrets.token_urlsafe(32),
        "cookie_secure": False
    }
}
