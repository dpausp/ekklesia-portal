# coding: utf-8
#
# Portal models
#
# Copyright (C) 2016-2017 by Thomas T. <ekklesia@heterarchy.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# For more details see the file COPYING.

from datetime import datetime, timedelta
import math

from ekklesia_common.database import Base, C, LIDType, integer_pk
from ekklesia_common.lid import LID
from ekklesia_common.utils import cached_property
from sqlalchemy import (
    JSON, Boolean, CheckConstraint, DateTime, Enum, ForeignKey, Integer, Numeric, Sequence, Text, Time,
    UniqueConstraint, func, select
)
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.ext.mutable import MutableDict
from sqlalchemy.orm import backref, object_session, relationship
from sqlalchemy_searchable import make_searchable
from sqlalchemy_utils.types import EmailType, TSVectorType, URLType

from ekklesia_portal.enums import (
    ArgumentType, Majority, PropositionStatus, PropositionVisibility, SecretVoterStatus, SupporterStatus, VoteByUser,
    VotingStatus, VotingSystem, VotingType
)

make_searchable(Base.metadata, options={'regconfig': 'pg_catalog.german'})


class Group(Base):
    __tablename__ = 'groups'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, unique=True, nullable=False)
    is_admin_group: bool = C(Boolean, nullable=False, server_default='false')
    members = association_proxy(
        'group_members', 'member', creator=lambda u: GroupMember(member=u)
    )  # <-GroupMember-> User


class User(Base):
    __tablename__ = 'users'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, unique=True, nullable=False)
    email: str = C(EmailType, unique=True, comment='optional, for notifications, otherwise use user/mails/')
    auth_type: str = C(
        Text, nullable=False, server_default='system', comment='deleted,system,token,virtual,oauth(has UserProfile)'
    )
    joined: datetime = C(DateTime, nullable=False, server_default=func.now())
    active: bool = C(Boolean, nullable=False, server_default='true')
    last_active: datetime = C(
        DateTime,
        nullable=False,
        server_default=func.now(),
        comment='last relevant activity (to be considered active member §2.2)'
    )
    can_login_until: datetime = C(
        DateTime, comment='optional expiration datetime after which login is no longer possible'
    )
    # actions: submit/support proposition, voting, or explicit, deactivate after 2 periods
    profile = relationship("UserProfile", uselist=False, back_populates="user")
    groups = association_proxy(
        'member_groups', 'group', creator=lambda g: GroupMember(group=g)
    )  # <-GroupMember-> Group
    # from user/membership/ all_nested_groups
    departments = association_proxy('member_departments', 'department')  # <-DepartmentMember-> Department
    areas = association_proxy('member_areas', 'area')  # <-AreaMember-> SubjectArea
    supports = association_proxy('member_propositions', 'proposition')  # <-Supporter-> Proposition
    arguments = relationship("Argument", back_populates="author")
    secret_voters = association_proxy('member_secretvoters', 'secretvoter')  # <-SecretVoter-> Ballot
    urns = association_proxy('member_urns', 'urn')  # <-UrnSupporter-> Urn
    postal_votes = association_proxy('member_postal', 'voting')  # <-PostalVote-> VotingPhase

    @property
    def managed_departments(self):
        return [md.department for md in self.member_departments if md.is_admin]

    @property
    def can_vote(self):
        if self.profile is None:
            return False

        return self.profile.eligible


class UserPassword(Base):
    __tablename__ = 'userpassword'
    user_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    user = relationship("User", backref=backref("password", uselist=False))
    hashed_password: str = C(Text)


class UserLoginToken(Base):
    __tablename__ = 'user_login_token'
    token: str = C(Text, primary_key=True)
    user_id: int = C(Integer, ForeignKey('users.id'))
    user = relationship("User", backref=backref("login_token", uselist=False))
    valid_until: datetime = C(DateTime)


class UserProfile(Base):
    __tablename__ = 'userprofiles'
    id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    user = relationship("User", back_populates="profile")
    sub: str = C(Text, unique=True)
    eligible: bool = C(Boolean)
    verified: bool = C(Boolean)
    profile: str = C(Text)


class GroupMember(Base):
    __tablename__ = 'groupmembers'

    group_id: int = C(Integer, ForeignKey('groups.id'), primary_key=True)
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    group = relationship("Group", backref=backref("group_members", cascade="all, delete-orphan"))
    member = relationship("User", backref=backref("member_groups", cascade="all, delete-orphan"))


class Department(Base):
    __tablename__ = 'departments'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, unique=True, nullable=False)
    description: str = C(Text)
    voting_phases = relationship('VotingPhase', back_populates='department', cascade='all, delete-orphan')
    members = association_proxy('department_members', 'member')  # <-DepartmentMember-> User
    areas = relationship("SubjectArea", back_populates="department")
    exporter_settings: dict = C(MutableDict.as_mutable(JSONB), server_default='{}')
    voting_module_settings: dict = C(MutableDict.as_mutable(JSONB), server_default='{}')
    """
    durations as INT+ENUM(days,weeks,months,periods)? quorum as num/denum(INT)?

     anonymousVoting BOOL # (false,NRW true) §5.1
     assignmentDeadline DURATION # deadline for secret/assignments before target date (5 weeks) §4.2
     conflictingDeadline DURATION # deadline for conflicting proposition before target date (5 weeks) §4.2
     expireActivity DURATION # inactive after periods (2) §2.2 (active by which actions?)
     extendedDiscussion BOOL #  (false) whether all argument relations are supported, otherwised only pro/contra and 1 level of refusal
     invitationDeadline DURATION # deadline for sending voting invitations before target date (4 weeks) §4.3
     memberTolerance DURATION # non-member tolerance duration (3 months) §3.6
     phaseDeadline DURATION # deadline for sending date announcement before target date (6 weeks) §4.1
     postalVoteDeadline DURATION # deadline for postal vote request before target date (1 week) $5.4
     postalVoteDeadline DURATION # deadline for secret vote request before voting starts (1 weeks) §4.4
     qualificationDeadline DURATION # deadline for first proposition before target date (7 weeks) §4.2
     registrationDeadline DURATION # deadline for vote registration before voting starts (3 days) $5.6
     reorderPropositions BOOL # reorder propositions (false, NRW: true) §4.2
     targetDayDistance DURATION # min. duration between target days (4 weeks, NRW 8 weeks) §4.1
     urnAcceptance DURATION # notification deadline for urn acceptance (3 weeks) §5b.2
     urnAssignments DURATION # notification deadline for urn assignment before target day (2 weeks) §5b.4
     urnClosing TIME # urn closing time (18:00) §5b.5
     urnDeadline DURATION # deadline for urn proposition before target day (4 weeks) §5b.2, §4.3
     urnDuration TIME # urn minimum duration (2 hours) §5b.5
     urnFinalAssignments DURATION # notification deadline for final urn assignments before target day (3 days) §5b.3
     urnMergeLimit INT # urn merge limit (10) §5b.6
     urnReassignment DURATION # deadline for urn reassignment before target day (1 week) §5b.4
     urnResponsible INT # minimum responsible members for urn (2) §5b.2
     urnVoters INT  # minimum urn voters (Bund/NRW 10, BY/HE 5) §5b.2
     urnVoting BOOL # (true) §5.1
     votingsPerPeriod INT # recommended votings per period (20) §5.2
    """


class DepartmentMember(Base):
    __tablename__ = 'departmentmembers'
    department_id: int = C(Integer, ForeignKey('departments.id'), primary_key=True)
    department = relationship("Department", backref=backref("department_members", cascade="all, delete-orphan"))
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_departments", cascade="all, delete-orphan"))
    is_admin: bool = C(Boolean, nullable=False, server_default='false')

    def __init__(self, department=None, member=None, is_admin=False):
        self.department = department
        self.member = member
        self.is_admin = is_admin


class SubjectArea(Base):  # Themenbereich §2.3+4
    __tablename__ = 'subjectareas'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, nullable=False)
    description: str = C(Text)
    department_id: int = C(Integer, ForeignKey('departments.id'), nullable=False)
    department = relationship("Department", back_populates="areas")
    ballots = relationship("Ballot", back_populates="area")
    # Themenbereichsteilnehmer
    # can only be removed if not proposition in this area supported §2.3
    members = association_proxy('area_members', 'member')  # <-AreaMember-> User
    documents = relationship('Document', back_populates='area')


class AreaMember(Base):
    __tablename__ = 'areamembers'
    area_id: int = C(Integer, ForeignKey('subjectareas.id'), primary_key=True)
    area = relationship("SubjectArea", backref=backref("area_members", cascade="all, delete-orphan"))
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_areas", cascade="all, delete-orphan"))

    def __init__(self, area=None, member=None):
        self.area = area
        self.member = member


class Policy(Base):  # Regelwerk
    __tablename__ = 'policies'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, unique=True, nullable=False)
    description: str = C(Text, server_default='')
    proposition_types = relationship("PropositionType", back_populates="policy")
    majority = C(Enum(Majority))
    proposition_expiration: int = C(Integer, comment='days to reach the qualification (supporter) quorum')
    qualification_minimum: int = C(Integer, comment='minimum for qualification quorum')
    qualification_quorum = C(
        Numeric(3, 2),
        comment='fraction of area members that must support a proposition for reaching the qualified state'
    )
    range_max: int = C(
        Integer, comment='maximum score used when the number of options is at least `range_small_options`'
    )
    range_small_max = C(
        Integer, comment='maximum score used when the number of options is less than `range_small_options`'
    )
    range_small_options = C(
        Integer, comment='largest number of options for which `range_small_max` is used as maximum score'
    )
    secret_minimum: int = C(Integer, comment='minimum for secret voting quorum')
    secret_quorum = C(Numeric(3, 2), comment='quorum to force a secret voting')
    submitter_minimum: int = C(Integer, comment='minimum number of submitters for a proposition')
    voting_duration: int = C(Integer, comment='voting duration in days; ends at target date')
    voting_system = C(Enum(VotingSystem))
    """
    configuration values also see department
         alwayssecret BOOL # §3.8
         areaMinimum INT # min. subject area members (500, BY/HE/NRW 250) §3.6
         certificateDuration DURATION # for secret ballot before voting starts (NRW 2 weeks) §4.5
         election BOOL # §3.8
         majority FRACTION # (1/2) $5d.1
         minCertificates INT # minimum valid certs for secret ballot(NRW 2) §5d.3+5
         propositionExpiration DURATION # (6 months) §3.8
         qualificationElection INT # absolute qualification quorum (20) §3.9
         qualificationQuorum FRACTION # (10%) §3.5
         rangeMax INT # (9) $5d.3
         rangeSmallMax INT # (3) $5d.3
         rangeSmallOptions INT # (5) $5d.3
         retractionDuration DURATION # (1 week) §3.4
         secretMinimum INT # min. secret vote members (50, BY/HE/NRW 25) §3.7
         secretQuorum FRACTION # secret vote quorum (5%) §3.5
         submissionQuorum INT # (5) §3.3
         supportExpiration DURATION # support expiration time (12 weeks) §3.5
         takeoverSupporters INT # (5) §3.4
         topicLockDuration DURATION # (12 month) §4.8
         votingDuration DURATION # (2 weeks) §4.5
         votingSystem ENUM # (range+approve voting) $5d.3
    """


class Tag(Base):
    __tablename__ = 'tags'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, unique=True, nullable=False)
    parent_id: int = C(Integer, ForeignKey('tags.id'))
    children = relationship("Tag", backref=backref('parent', remote_side=[id]))
    mut_exclusive: bool = C(
        Boolean, nullable=False, server_default='false', comment='whether all children are mutually exclusive'
    )
    propositions = association_proxy('tag_propositions', 'proposition')  # <-PropositionTag-> Proposition


class PropositionType(Base):  # Antragsart
    __tablename__ = 'propositiontypes'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text, unique=True, nullable=False)
    abbreviation: str = C(Text, unique=True, nullable=False)
    description: str = C(Text, server_default='')
    policy_id: int = C(Integer, ForeignKey('policies.id'), nullable=False)
    policy: Policy = relationship("Policy", back_populates="proposition_types")
    ballots = relationship("Ballot", back_populates="proposition_type")


class Ballot(Base):  # conflicting qualified propositions
    __tablename__ = 'ballots'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    name: str = C(Text)
    # <- propositions Proposition[]
    # XXX: not sure if we need a status here. Add missing states to PropositionStatus or the other way round?
    # status: str = C(Text, nullable=False)  # submitted?, qualified, locked, obsolete # §4.8 §5.2
    election: int = C(Integer, nullable=False, server_default='0')  # 0=no election, otherwise nr of positions, §5d.4+5
    # §3.8, one proposition is for qualification of election itself
    voting_type: VotingType = C(Enum(VotingType))  # online, urn, assembly, board
    proposition_type_id: int = C(Integer, ForeignKey('propositiontypes.id'))
    proposition_type: PropositionType = relationship("PropositionType", back_populates="ballots")

    area_id: int = C(Integer, ForeignKey('subjectareas.id'))
    area = relationship("SubjectArea", back_populates="ballots")  # contains department

    # optional, if assigned, set proposition to planned
    voting_id: int = C(Integer, ForeignKey('votingphases.id'))
    voting = relationship("VotingPhase", back_populates="ballots")

    secret_voters = association_proxy('ballot_members', 'member')  # <-SecretVoter-> User

    propositions = relationship("Proposition", back_populates="ballot")
    # <-result   VotingResult # optional
    result: dict = C(MutableDict.as_mutable(JSONB))
    # <-  propositions Proposition[]
    # requirements for assignment:
    #  deadline for first and conflicting proposition before target date §4.2
    #  later conflicting proposition are assigned to a new independent ballot


class VotingPhaseType(Base):
    __tablename__ = 'voting_phase_types'
    id: int = integer_pk()
    name: str = C(Text, server_default='', comment='readable name')
    abbreviation: str = C(Text, server_default='', comment='abbreviated name')
    secret_voting_possible: bool = C(Boolean, nullable=False)
    voting_type = C(Enum(VotingType), nullable=False)  # online, urn, assembly, board
    registration_start_days: int = C(Integer, comment='voter registration start in days relative to target date')
    registration_end_days: int = C(Integer, comment='voter registration end in days relative to target date')
    voting_days: int = C(Integer, comment='voting duration in days; ends at target date')
    description: str = C(Text, server_default='')


class VotingPhase(Base):  # Abstimmungsperiode
    __tablename__ = 'votingphases'
    __table_args__ = (
        CheckConstraint("status='PREPARING' OR (status!='PREPARING' AND target IS NOT NULL)", 'state_valid'),
    )
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    status: VotingStatus = C(Enum(VotingStatus), nullable=False, server_default='PREPARING')
    target: datetime = C(DateTime, comment='constrained by §4.1')
    registration_start_days: int = C(Integer, comment='voter registration start in days relative to target date')
    registration_end_days: int = C(Integer, comment='voter registration end in days relative to target date')
    voting_days: int = C(Integer, comment='voting duration in days; ends at target date')
    department_id: int = C(Integer, ForeignKey('departments.id'), nullable=False)
    phase_type_id: int = C(Integer, ForeignKey('voting_phase_types.id'), nullable=False)
    secret: bool = C(
        Boolean,
        nullable=False,
        server_default='false',
        comment='whether any secret votes will take place (decision deadline §4.2)'
    )
    name: str = C(Text, server_default='', comment='short, readable name which can be used for URLs')
    title: str = C(Text, server_default='')
    description: str = C(Text, server_default='')
    voting_module_data: dict = C(MutableDict.as_mutable(JSONB), server_default='{}')
    ballots = relationship("Ballot", back_populates="voting")
    department = relationship('Department', back_populates='voting_phases')
    phase_type = relationship('VotingPhaseType')
    # <- urns    Urn[]
    urns = relationship("Urn", back_populates="voting")
    postal_votes = association_proxy('voting_postal', 'member')  # <-PostalVote-> User
    # send announcement before deadline §4.1
    # send voting invitation before deadline §4.3
    # deadline for vote registration before voting starts $5.6
    # shall not assign more than recommended votings per period §5.2
    # ask submitters for veto for move to other phase §5.3

    @property
    def ballots_can_be_added(self):
        return self.status == VotingStatus.PREPARING

    @property
    def registration_start(self):
        if self.target is None:
            return

        days = self.registration_start_days or self.phase_type.registration_start_days

        if days is None:
            return

        return self.target - timedelta(days=days)

    @property
    def registration_end(self):
        """Registration ends at `target - registration_end_days` or
        at `target` if registration_end_days is not set"""
        if self.target is None:
            return

        days = self.registration_end_days or self.phase_type.registration_end_days or 0

        return self.target - timedelta(days=days)

    @property
    def voting_can_be_created(self):
        return self.status == VotingStatus.PREPARING and self.voting_start is not None and self.voting_end is not None

    @property
    def voting_start(self):
        if self.target is None:
            return

        days = self.voting_days or self.phase_type.voting_days

        if days is None:
            return

        return self.target - timedelta(days=days)

    @property
    def voting_end(self):
        return self.target


class Supporter(Base):  # §3.5
    __tablename__ = 'supporters'
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_propositions", cascade="all, delete-orphan"))
    proposition_id: LID = C(LIDType, ForeignKey('propositions.id'), primary_key=True)
    proposition = relationship("Proposition", backref=backref("propositions_member", cascade="all, delete-orphan"))
    submitter: bool = C(Boolean, nullable=False, server_default='false', comment='submitter or regular')
    status: SupporterStatus = C(Enum(SupporterStatus), nullable=False, server_default='ACTIVE')
    last_change: datetime = C(DateTime, nullable=False, server_default=func.now(), comment='last status change')


class SecretVoter(Base):  # §3.7, §4.4
    __tablename__ = 'secretvoters'
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_ballots", cascade="all, delete-orphan"))
    ballot_id: int = C(Integer, ForeignKey('ballots.id'), primary_key=True)
    ballot = relationship("Ballot", backref=backref("ballot_members", cascade="all, delete-orphan"))

    status: SecretVoterStatus = C(Enum(SecretVoterStatus), nullable=False)  # active,expired,retracted
    last_change: datetime = C(DateTime, nullable=False)  # time of requested/retracted
    # can only be requested before deadline before voting starts §4.4
    # qualification §4.4 (immediate check): for count active members (minimum number §3.7),
    #  calculate quorum, if supporters >= quorum, set ballot to secret


class Proposition(Base):
    __tablename__ = 'propositions'
    id: LID = C(LIDType, default=LID, primary_key=True)
    title: str = C(Text, nullable=False)
    content: str = C(Text, nullable=False)  # modifies: generate diff to original dynamically
    abstract: str = C(Text, nullable=False, server_default='')
    motivation: str = C(Text, nullable=False, server_default='')
    voting_identifier: str = C(Text)
    created_at: datetime = C(DateTime, nullable=False, server_default=func.now())
    submitted_at: datetime = C(
        DateTime, comment='optional, §3.1, for order of voting §5.3, date of change if original (§3.4)'
    )
    qualified_at: datetime = C(DateTime, comment='optional, when qualified')
    status: PropositionStatus = C(Enum(PropositionStatus), nullable=False, server_default='DRAFT')
    submitter_invitation_key: str = C(Text)

    author_id: int = C(Integer, ForeignKey('users.id'))
    author = relationship("User", backref=backref("authored_propositions"))

    ballot_id: int = C(Integer, ForeignKey('ballots.id'), nullable=False)
    ballot: Ballot = relationship(
        "Ballot", uselist=False, back_populates="propositions"
    )  # contains area (department), propositiontype

    supporters = association_proxy('propositions_member', 'member')  # <-Supporter-> User
    # in state draft only submitters may become supporters §3.3
    tags = association_proxy('proposition_tags', 'tag')  # <-PropositionTag-> Tag

    modifies_id: LID = C(LIDType, ForeignKey('propositions.id'), comment='only one level allowed')
    derivations = relationship("Proposition", foreign_keys=[modifies_id], backref=backref('modifies', remote_side=[id]))

    replaces_id: LID = C(LIDType, ForeignKey('propositions.id'))  # optional
    replacements = relationship(
        "Proposition", foreign_keys=[replaces_id], backref=backref('replaces', remote_side=[id])
    )

    changesets = relationship('Changeset', back_populates='proposition')

    external_discussion_url: str = C(URLType)

    external_fields: dict = C(
        MutableDict.as_mutable(JSONB),
        comment='Fields that are imported from or exported to other systems but are not interpreted by the portal.',
        server_default='{}'
    )

    visibility: PropositionVisibility = C(Enum(PropositionVisibility), nullable=False, server_default='PUBLIC')

    search_vector = C(
        TSVectorType(
            'title',
            'abstract',
            'content',
            'motivation',
            'voting_identifier',
            weights={
                'title': 'A',
                'voting_identifier': 'A',
                'abstract': 'B',
                'content': 'C',
                'motivation': 'D'
            }
        )
    )

    __table_args__ = (
        CheckConstraint(
            "qualified_at IS NOT NULL OR status IN ('DRAFT', 'SUBMITTED', 'ABANDONED', 'CHANGING', 'FINISHED')",
            name="qualified_at_must_be_set"
        ),
        CheckConstraint(
            "submitted_at IS NOT NULL OR status IN ('DRAFT', 'ABANDONED', 'CHANGING')", name="submitted_at_must_be_set"
        )
    )

    @property
    def _area_members_count(self):
        return len([s for s in self.ballot.area.members])

    @property
    def qualification_quorum(self):
        policy = self.ballot.proposition_type.policy
        quorum = math.ceil(self._area_members_count * policy.qualification_quorum / 100)
        return max(quorum, policy.qualification_minimum)

    @property
    def secret_voters_count(self):
        return len([s for s in self.ballot.ballot_members if s.status == SecretVoterStatus.ACTIVE])

    @property
    def secret_voting_quorum(self):
        policy = self.ballot.proposition_type.policy
        quorum = math.ceil(self._area_members_count * policy.secret_quorum / 100)
        return max(quorum, policy.secret_minimum)

    def support_by_user(self, user) -> Supporter:
        for s in self.propositions_member:
            if s.member_id == user.id and s.status == SupporterStatus.ACTIVE:
                return s

    def user_is_submitter(self, user) -> bool:
        for s in self.propositions_member:
            if s.member_id == user.id and s.submitter:
                return True

        return False

    @hybrid_property
    def active_supporter_count(self):
        return len([s for s in self.propositions_member if s.status == SupporterStatus.ACTIVE])

    @active_supporter_count.expression
    def active_supporter_count(cls):
        return select([func.count()]).where(Supporter.proposition_id == cls.id
                                            ).where(Supporter.status == SupporterStatus.ACTIVE)

    @property
    def submitter_count(self):
        return len([s for s in self.propositions_member if s.submitter])

    @property
    def ready_to_submit(self):
        return self.status == PropositionStatus.DRAFT and self.submitter_count >= self.ballot.proposition_type.policy.submitter_minimum

    """
   submission data: content, submitters, conflicts
   perform daily checks
   change only if submitted §3.4:
    1. create copy as draft until all submitters agree (set parent)
    2. copy supporters to new proposition and replace original in its conflicts
       for original: set status to changing and original submitters to retracted (takeover submitters= active)
    3a. if takeover within timelimit, submit new version as new conflicting proposition and remove old supporters, original status=submitted
    3b. otherwise set original to abandoned
   retraction: when all retracted and timelimit passed, set to status abandoned, remove from conflicts
   qualification §3.5 (immediate check): for each area count members (minimum number §3.6), calculate quorum,
   if supporters >= quorum, set to state qualified
   expiration: for submitted proposition, if supporter > expiration time, set to expired
     if proposition in submitted state for proposition expiration time §3.8, set to abandoned, expire supporters?
     if vote on Parteitag, set to finished with results §3.8
   elections: first normal proposition for election itself, then candidates in ballot §3.9
    """


class PropositionTag(Base):
    __tablename__ = 'propositiontags'
    proposition_id: LID = C(LIDType, ForeignKey('propositions.id'), primary_key=True)
    proposition = relationship("Proposition", backref=backref("proposition_tags", cascade="all, delete-orphan"))
    tag_id: int = C(Integer, ForeignKey('tags.id'), primary_key=True)
    tag = relationship("Tag", backref=backref("tag_propositions", cascade="all, delete-orphan"))

    def __init__(self, tag=None, proposition=None):
        self.tag = tag
        self.proposition = proposition


class PropositionNote(Base):
    __tablename__ = 'propositionnotes'
    proposition_id: LID = C(LIDType, ForeignKey('propositions.id'), primary_key=True)
    user_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    notes: str = C(Text)
    vote: VoteByUser = C(Enum(VoteByUser))

    def __init__(self, user, id, notes=None, vote=VoteByUser.UNSURE):
        self.proposition_id = id
        self.user_id = user
        self.notes = notes
        self.vote = vote


class Argument(Base):
    __tablename__ = 'arguments'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    title: str = C(Text, nullable=False)
    abstract: str = C(Text, nullable=False)
    details: str = C(Text)
    author_id: int = C(Integer, ForeignKey('users.id'))
    author = relationship("User", backref=backref("member_arguments", cascade="all, delete-orphan"))
    created_at: datetime = C(DateTime, nullable=False, server_default=func.now())


class ArgumentRelation(Base):
    __tablename__ = 'argumentrelations'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    parent_id: int = C(Integer, ForeignKey('argumentrelations.id'), comment='only for inter-arguments')
    children = relationship("ArgumentRelation", backref=backref('parent', remote_side=[id]))

    argument_id: int = C(Integer, ForeignKey('arguments.id'))
    argument = relationship("Argument", backref=backref("argument_relations", cascade="all, delete-orphan"))
    proposition_id: LID = C(LIDType, ForeignKey('propositions.id'))
    proposition = relationship("Proposition", backref=backref("proposition_arguments", cascade="all, delete-orphan"))
    argument_type: ArgumentType = C(Enum(ArgumentType), nullable=False)

    def user_vote(self, user):
        return object_session(self).query(ArgumentVote).filter_by(relation=self, member=user).scalar()

    @cached_property
    def score(self):
        return sum(rv.weight for rv in self.relation_votes)


class ArgumentVote(Base):
    __tablename__ = 'argumentvotes'
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_argumentvotes", cascade="all, delete-orphan"))
    relation_id: int = C(Integer, ForeignKey('argumentrelations.id'), primary_key=True)
    relation = relationship("ArgumentRelation", backref=backref("relation_votes", cascade="all, delete-orphan"))
    weight: int = C(Integer, nullable=False, comment='if extendedDiscussion: --(-2),-,0,+,++(+2) , otherwise -1 and +1')


class PostalVote(Base):  # §5.4
    __tablename__ = 'postalvotes'
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_postal", cascade="all, delete-orphan"))
    voting_id: int = C(Integer, ForeignKey('votingphases.id'), primary_key=True)  # option, empty=permanent
    voting = relationship("VotingPhase", backref=backref("voting_postal", cascade="all, delete-orphan"))
    # can only be requested before deadline before voting starts §5.4
    # deleted when member becomes inactive
    # must not be urn supporter


class Urn(Base):
    __tablename__ = 'urns'
    id: int = C(Integer, Sequence('id_seq', optional=True), primary_key=True)
    voting_id: int = C(Integer, ForeignKey('votingphases.id'), nullable=False)
    voting = relationship("VotingPhase", back_populates="urns")
    accepted: bool = C(Boolean, nullable=False, server_default='false')
    location: str = C(Text, nullable=False)
    description: str = C(Text)
    opening = C(Time)  # §5b.5
    supporters = association_proxy('urn_members', 'member')  # <-UrnSupporter-> User
    # see deadlines and requirements in config


class UrnSupporter(Base):  # §5b.2
    __tablename__ = 'urnsupporters'
    member_id: int = C(Integer, ForeignKey('users.id'), primary_key=True)
    member = relationship("User", backref=backref("member_urns", cascade="all, delete-orphan"))
    urn_id: int = C(Integer, ForeignKey('urns.id'), primary_key=True)
    urn = relationship("Urn", backref=backref("urn_members", cascade="all, delete-orphan"))

    type: str = C(Text, nullable=False)  # responsible, request, voter # §5b.2+4
    voted: bool = C(Boolean, nullable=False, server_default='false')  # §5b.6
    # urn merge if below min. no of voters §5b.6


class Page(Base):
    __tablename__ = 'page'
    name: str = C(Text, primary_key=True)
    lang: str = C(Text, primary_key=True)
    title: str = C(Text)
    text: str = C(Text)
    permissions = C(JSON)


class CustomizableText(Base):
    __tablename__ = 'customizable_text'
    name: str = C(Text, primary_key=True)
    lang: str = C(Text, primary_key=True)
    text: str = C(Text)
    permissions = C(JSON)


class Document(Base):
    __tablename__ = 'document'
    id: int = integer_pk()
    name: str = C(Text)
    lang: str = C(Text)
    area_id: int = C(Integer, ForeignKey('subjectareas.id'))
    area = relationship('SubjectArea', back_populates='documents')  # contains department
    text: str = C(Text)
    description: str = C(Text)
    proposition_type_id: int = C(Integer, ForeignKey('propositiontypes.id'))
    proposition_type = relationship('PropositionType')
    changesets = relationship('Changeset', back_populates='document')
    __table_args__ = (UniqueConstraint(name, lang, area_id), )


class Changeset(Base):
    __tablename__ = 'changeset'
    id: int = integer_pk()
    document_id: int = C(Integer, ForeignKey('document.id'), nullable=False)
    proposition_id: LID = C(LIDType, ForeignKey('propositions.id'), nullable=False)
    document = relationship(Document, back_populates='changesets')
    proposition = relationship(Proposition, back_populates='changesets')
    section: str = C(Text, comment='Identifier for the section of the document that is changed.')
