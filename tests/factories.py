import string
from factory import Factory, SubFactory
from factory.alchemy import SQLAlchemyModelFactory
from factory.fuzzy import FuzzyChoice, FuzzyText
from mimesis_factory import MimesisField
from pytest_factoryboy import register
from ekklesia_portal.database import Session
from ekklesia_portal.enums import EkklesiaUserType
from ekklesia_portal.ekklesia_auth import EkklesiaAuthData, EkklesiaAUIDData, EkklesiaProfileData, EkklesiaMembershipData
from ekklesia_portal.database.datamodel import Proposition, Argument, ArgumentRelation, User


class SQLAFactory(SQLAlchemyModelFactory):
    class Meta:
        sqlalchemy_session = Session


@register
class UserFactory(SQLAFactory):
    class Meta:
        model = User

    auth_type = 'system'
    name = MimesisField('username', template='l_d')


register(UserFactory, 'user_two')


@register
class PropositionFactory(SQLAFactory):
    class Meta:
        model = Proposition

    title = MimesisField('title')
    content = MimesisField('text', quantity=100)
    abstract = MimesisField('text', quantity=20)


register(PropositionFactory, 'proposition_two')


@register
class ArgumentFactory(SQLAFactory):
    class Meta:
        model = Argument


@register
class ArgumentRelationFactory(SQLAFactory):
    class Meta:
        model = ArgumentRelation


@register
class EkklesiaMembershipDataFactory(Factory):
    class Meta:
        model = EkklesiaMembershipData

    nested_groups = all_nested_groups = [1, 2, 3]
    type = FuzzyChoice([EkklesiaUserType.PLAIN_MEMBER,
                        EkklesiaUserType.ELIGIBLE_MEMBER,
                        EkklesiaUserType.GUEST,
                        EkklesiaUserType.SYSTEM_USER])
    verified = FuzzyChoice([True, False])


@register
class EkklesiaProfileDataFactory(Factory):
    class Meta:
        model = EkklesiaProfileData

    username = MimesisField('username', template='l_d')
    profile = MimesisField('text', quantity=2)
    avatar = ''


@register
class EkklesiaAUIDDataFactory(Factory):
    class Meta:
        model = EkklesiaAUIDData

    auid = MimesisField('uuid')


@register
class EkklesiaAuthDataFactory(Factory):
    class Meta:
        model = EkklesiaAuthData

    membership = SubFactory(EkklesiaMembershipDataFactory)
    profile = SubFactory(EkklesiaProfileDataFactory)
    auid = SubFactory(EkklesiaAUIDDataFactory)
    token = FuzzyText(length=30, chars=string.ascii_letters + string.digits)
