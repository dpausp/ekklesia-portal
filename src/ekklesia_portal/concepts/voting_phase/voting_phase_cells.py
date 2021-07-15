from collections import namedtuple
from dataclasses import dataclass
from datetime import datetime
from ekklesia_portal.app import App
from ekklesia_portal.concepts.ekklesia_portal.cell.form import EditFormCell, NewFormCell
from ekklesia_portal.concepts.ekklesia_portal.cell.layout import LayoutCell
from ekklesia_portal.datamodel import Department, VotingPhase, VotingPhaseType
from ekklesia_portal.enums import VotingStatus
from ekklesia_portal.permission import CreatePermission, EditPermission

from .voting_phase_helper import items_for_voting_phase_select_widgets
from .voting_phase_permissions import ManageVotingPermission
from .voting_phases import VotingPhases


@App.cell(VotingPhases)
class VotingPhasesCell(LayoutCell):

    def voting_phases(self):
        return list(self._model.voting_phases(self._request.q))

    def show_new_button(self):
        return self._request.permitted_for_current_user(self._model, CreatePermission)


@App.cell(VotingPhase)
class VotingPhaseCell(LayoutCell):

    model_properties = [
        'ballots',
        'department',
        'description',
        'name',
        'phase_type',
        'registration_end',
        'registration_start',
        'secret',
        'status',
        'target',
        'title',
        'voting_end',
        'voting_start',
    ]

    def show_edit_button(self):
        return self.options.get('show_edit_button'
                                ) and self._request.permitted_for_current_user(self._model, EditPermission)

    def department_name(self):
        return self._model.department.name

    def department_url(self):
        return self.link(self._model.department)

    def show_voting_details(self):
        if not self.options.get("show_voting_details"):
            return

        if self._model.status not in (VotingStatus.PREPARING, VotingStatus.VOTING):
            return

        return datetime.now() < self.voting_end

    def show_registration_period(self):
        if self.registration_start is None:
            return

        return datetime.now() < self.registration_end

    def show_voting_period(self):
        if self.voting_start is None:
            return

        return datetime.now() < self.voting_end

    def can_participate_in_voting(self):
        user = self._request.current_user
        if user is None:
            return

        if self._model.department not in user.departments:
            return

        return user.can_vote

    def show_registration(self):
        """Determines if registration info should be shown.
        This only applies to voting phases that have a registration period.
        (registration_start_days is set).
        """
        if not self.can_participate_in_voting:
            return

        if self.registration_start is None:
            return

        if not self.votings:
            return

        return self.registration_start < datetime.now() < self.registration_end

    def show_will_be_able_to_vote(self):
        if self._request.current_user is None:
            return

        if self._model.status not in (VotingStatus.PREPARING, VotingStatus.VOTING):
            return

        if self.registration_start:
            return datetime.now() < self.registration_start
        elif self.voting_start:
            return datetime.now() < self.voting_start
        else:
            return True

    def show_voting(self):
        """Determines if voting info should be shown.
        This only applies to voting phases that don't have a registration period.
        (registration_start_days is not set).
        """
        if not self.can_participate_in_voting:
            return

        if self.registration_start is not None:
            return

        if not self.votings:
            return

        return self.voting_start < datetime.now() < self.voting_end

    def propositions(self):
        return [p for b in self._model.ballots for p in b.propositions]

    def votings(self):
        votings = []
        for name, settings in self._model.department.voting_module_settings.items():
            voting_module_data = self._model.voting_module_data.get(name)
            if voting_module_data and (voting_url := voting_module_data.get('config_url')):
                title = settings.get('title', name)
                votings.append((title, voting_url))

        return votings


@App.cell(VotingPhases, 'new')
class NewVotingPhaseCell(NewFormCell):

    def _prepare_form_for_render(self):
        identity = self._request.identity

        if identity.has_global_admin_permissions:
            departments = self._request.q(Department)
        else:
            departments = identity.user.managed_departments

        phase_types = self._request.q(VotingPhaseType)
        items = items_for_voting_phase_select_widgets(phase_types, departments)
        self._form.prepare_for_render(items)


@App.cell(VotingPhase, 'edit')
class EditVotingPhaseCell(EditFormCell):

    model_properties = [
        'voting_days',
        'registration_end_days',
        'registration_start_days',
    ]

    def _prepare_form_for_render(self):
        form_data = self._model.to_dict()
        self.set_form_data(form_data)
        identity = self._request.identity

        if identity.has_global_admin_permissions:
            departments = self._request.q(Department)
        else:
            departments = identity.user.managed_departments

        phase_types = self._request.q(VotingPhaseType)
        items = items_for_voting_phase_select_widgets(phase_types, departments, self._model)
        self._form.prepare_for_render(items)

    def propositions(self):
        return [p for b in self._model.ballots for p in b.propositions]

    def show_create_voting(self):
        return self.voting_modules and self.propositions and self._model.voting_can_be_created and self._request.permitted_for_current_user(
            self._model, ManageVotingPermission
        )

    def show_inherited_properties(self):
        if not self.inherited_properties:
            return

        return self._model.status == VotingStatus.PREPARING

    def inherited_properties(self):
        PropertyItem = namedtuple("PropertyItem", ["property", "value"])
        properties = []
        phase_type = self._model.phase_type

        if not self.registration_start_days:
            properties.append(PropertyItem('registration_start_days', phase_type.registration_start_days))
        if not self.registration_end_days:
            properties.append(PropertyItem('registration_end_days', phase_type.registration_end_days))
        if not self.voting_days:
            properties.append(PropertyItem('voting_days', phase_type.voting_days))

        return properties

    def voting_modules(self):
        # value is True if there's already a configured voting
        return [(name, name not in self._model.voting_module_data)
                for name in self._model.department.voting_module_settings]

    def create_voting_action(self):
        return self._request.link(self._model, "create_voting")
