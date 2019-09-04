import logging
import os.path
from pathlib import Path
from pytest import fixture
from morepath.request import BaseRequest
from webtest import TestApp as Client
from ekklesia_portal.app import make_wsgi_app
from ekklesia_portal.identity_policy import UserIdentity
from ekklesia_portal.request import EkklesiaPortalRequest
from ekklesia_portal.database import Session
from ekklesia_portal.database.datamodel import Proposition, User, DepartmentMember
from ekklesia_portal.enums import ArgumentType

ROOT_DIR = Path(__file__).absolute().parent.parent
logg = logging.getLogger(__name__)


@fixture(scope="session")
def config_filepath():
    return ROOT_DIR / "testconfig.yml"


@fixture(scope="session")
def app(config_filepath):
    app = make_wsgi_app(config_filepath, testing=True)
    return app


@fixture
def client(app):
    return Client(app)


@fixture
def req(app):
    environ = BaseRequest.blank('test').environ
    return EkklesiaPortalRequest(environ, app)


@fixture
def db_session(app):
    return Session()


@fixture
def db_query(app):
    return Session().query


@fixture
def proposition_with_arguments(user, user_two, proposition, argument_factory, argument_relation_factory):
    arg1 = argument_factory(author=user, title='Ein Pro-Argument', abstract='dafür abstract', details='dafür')
    arg2 = argument_factory(author=user_two, title='Ein zweites Pro-Argument', abstract='dafür!!!')
    arg3 = argument_factory(author=user, title='Ein Contra-Argument', abstract='dagegen!!!', details='aus Gründen')
    arg1_rel = argument_relation_factory(proposition=proposition, argument=arg1, argument_type=ArgumentType.PRO)
    arg2_rel = argument_relation_factory(proposition=proposition, argument=arg2, argument_type=ArgumentType.PRO)
    arg3_rel = argument_relation_factory(proposition=proposition, argument=arg3, argument_type=ArgumentType.CONTRA)
    return proposition


@fixture
def user_with_departments(user_factory, department_factory):
    user = user_factory()
    departments = [department_factory(), department_factory()]
    user.departments = departments

    for department in departments:
        user.areas.extend(department.areas)

    return user


@fixture
def logged_in_user(user, monkeypatch):
    user_identity = UserIdentity(user)
    monkeypatch.setattr('ekklesia_portal.request.EkklesiaPortalRequest.identity', user_identity)
    return user


@fixture
def logged_in_user_with_departments(user_with_departments, monkeypatch):
    user = user_with_departments
    user_identity = UserIdentity(user)
    monkeypatch.setattr('ekklesia_portal.request.EkklesiaPortalRequest.identity', user_identity)
    return user


@fixture
def department_admin(db_session, user_factory, department_factory):
    user = user_factory()
    d1 = department_factory(description='admin')
    d2 = department_factory(description='not admin')
    dm = DepartmentMember(member=user, department=d1, is_admin=True)
    db_session.add(dm)
    user.departments.append(d2)
    return user


@fixture
def logged_in_department_admin(department_admin, monkeypatch):
    user_identity = UserIdentity(department_admin)
    monkeypatch.setattr('ekklesia_portal.request.EkklesiaPortalRequest.identity', user_identity)
    return department_admin


@fixture(autouse=True)
def no_db_commit(monkeypatch):
    def dummy_commit(*a, **kw):
        logg.debug('would commit now')

    monkeypatch.setattr('transaction.manager.commit', dummy_commit)
