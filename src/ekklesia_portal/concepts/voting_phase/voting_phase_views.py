from ekklesia_common import md
from morepath import redirect
from sqlalchemy.log import echo_property
from webob.exc import HTTPBadRequest
from eliot import start_action

from ekklesia_portal.app import App
from ekklesia_portal.datamodel import VotingPhase, VotingPhaseType
from ekklesia_portal.enums import VotingStatus
from ekklesia_portal.lib.identity import identity_manages_department, identity_manages_any_department
from ekklesia_portal.lib.voting import InvalidVotingModule, prepare_module_config
from ekklesia_portal.lib.vvvote import create_election_in_vvvote
from ekklesia_portal.lib.vvvote.election_config import voting_phase_to_vvvote_election_config
from ekklesia_portal.permission import CreatePermission, EditPermission

from .voting_phase_cells import EditVotingPhaseCell, NewVotingPhaseCell, VotingPhaseCell, VotingPhasesCell
from .voting_phase_contracts import VotingPhaseForm
from .voting_phases import VotingPhases
from .voting_phase_permissions import ManageVotingPermission


@App.permission_rule(model=VotingPhases, permission=CreatePermission)
def voting_phases_create_permission(identity, model, permission):
    return identity_manages_any_department(identity)


@App.permission_rule(model=VotingPhase, permission=EditPermission)
def voting_phase_edit_permission(identity, model, permission):
    return identity_manages_department(identity, model.department)


@App.permission_rule(model=VotingPhase, permission=ManageVotingPermission)
def voting_phase_edit_permission(identity, model, permission):
    return identity_manages_department(identity, model.department)


@App.path(model=VotingPhases, path='v')
def voting_phases():
    return VotingPhases()


@App.path(model=VotingPhase, path='v/{id}/{slug}', variables=lambda o: dict(id=o.id, slug=o.name or o.target or o.id))
def voting_phase_path(request, id, slug):
    return request.q(VotingPhase).get(id)


@App.html(model=VotingPhases)
def index(self, request):
    cell = VotingPhasesCell(self, request)
    return cell.show()


@App.html(model=VotingPhases, name='new', permission=CreatePermission)
def new(self, request):
    form = VotingPhaseForm(request, request.link(self))
    return NewVotingPhaseCell(request, form, form_data={}).show()


@App.html_form_post(model=VotingPhases, form=VotingPhaseForm, cell=NewVotingPhaseCell, permission=CreatePermission)
def create(self, request, appstruct):
    department_id = appstruct['department_id']

    if not request.identity.has_global_admin_permissions:
        department_allowed = [d for d in request.current_user.managed_departments if d.id == department_id]

        if not department_allowed:
            return HTTPBadRequest("department not allowed")

    voting_phase_type = request.q(VotingPhaseType).get(appstruct['phase_type_id'])

    if voting_phase_type is None:
        return HTTPBadRequest("voting phase type is missing")

    voting_phase = VotingPhase(**appstruct)
    request.db_session.add(voting_phase)
    request.db_session.flush()

    return redirect(request.link(voting_phase))


@App.html(model=VotingPhase, name='edit', permission=EditPermission)
def edit(self, request):
    form = VotingPhaseForm(request, request.link(self))
    return EditVotingPhaseCell(self, request, form).show()


@App.html_form_post(model=VotingPhase, form=VotingPhaseForm, cell=EditVotingPhaseCell, permission=EditPermission)
def update(self, request, appstruct):
    department_id = appstruct['department_id']

    if not request.identity.has_global_admin_permissions:
        department_allowed = [d for d in request.current_user.managed_departments if d.id == department_id]

        if not department_allowed:
            return HTTPBadRequest("department not allowed")

    phase_type = request.q(VotingPhaseType).get(appstruct['phase_type_id'])

    if phase_type is None:
        return HTTPBadRequest("voting phase type is missing")

    previous_status = self.status

    self.update(**appstruct)

    # Fill values from voting phase type when transitioning from PREPARING to VOTING.
    # We don't want to touch these values anymore when VOTING even if the voting phase type changes
    if previous_status == VotingStatus.PREPARING and self.status == VotingStatus.VOTING:
        if not self.voting_days:
            self.voting_days = phase_type.voting_days
        if not self.registration_start_days:
            self.registration_start_days = phase_type.registration_start_days
        if not self.registration_end_days:
            self.registration_end_days = phase_type.registration_end_days

    return redirect(request.link(self))


@App.html(model=VotingPhase)
def show(self, request):
    cell = VotingPhaseCell(
        self, request, show_edit_button=True, show_voting_details=True, show_proposition_list=True, full_view=True
    )
    return cell.show()


@App.json(model=VotingPhase, name='spickerrr')
def spickerrr(self, request):
    propositions = [p for b in self.ballots for p in b.propositions]

    def serialize_proposition(proposition):
        proposition_type = proposition.ballot.proposition_type
        return {
            'url': request.link(proposition),
            'id': proposition.voting_identifier,
            'title': proposition.title,
            'type': proposition_type.name if proposition_type else None,
            'tags': ', '.join(t.name for t in proposition.tags),
            'text': md.convert(proposition.content),
            'remarks': md.convert(proposition.motivation)
        }

    return [serialize_proposition(p) for p in propositions]


@App.html(model=VotingPhase, name="create_voting", request_method="POST", permission=EditPermission)
def create_voting(self, request):
    if not self.voting_can_be_created:
        raise HTTPBadRequest("Voting phase is in the wrong state or target date is not set")

    voting_module_name = request.POST.get("create_voting")

    try:
        module_config = prepare_module_config(request.app, self.department, voting_module_name)
    except InvalidVotingModule as e:
        raise HTTPBadRequest(e.args[0])

    with start_action(action_type="create_vvvote_election_config", module_config=module_config):
        election_config = voting_phase_to_vvvote_election_config(module_config, self).to_json()

    with start_action(action_type="create_election_in_vvvote", election_config=election_config) as action:
        config_url = create_election_in_vvvote(module_config, election_config)
        self.voting_module_data[voting_module_name] = {"config_url": config_url}
        action.add_success_fields(config_url=config_url)

    _ = request.i18n.gettext

    request.flash(_("voting_created_msg", voting_module=voting_module_name), "success")

    return redirect(request.link(self))
