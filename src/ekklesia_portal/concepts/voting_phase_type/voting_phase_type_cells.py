from ekklesia_portal.app import App
from ekklesia_portal.concepts.ekklesia_portal.cell.layout import LayoutCell
from ekklesia_portal.concepts.ekklesia_portal.cell.form import NewFormCell, EditFormCell
from ekklesia_portal.datamodel import VotingPhaseType
from ekklesia_portal.permission import CreatePermission, EditPermission
from .voting_phase_type_helper import items_for_voting_phase_type_select_widgets
from .voting_phase_types import VotingPhaseTypes


@App.cell(VotingPhaseTypes)
class VotingPhaseTypesCell(LayoutCell):

    def voting_phase_types(self):
        return list(self._model.voting_phase_types(self._request.q))

    def show_new_button(self):
        return self.options.get('show_new_button'
                                ) and self._request.permitted_for_current_user(self._model, CreatePermission)


@App.cell(VotingPhaseType)
class VotingPhaseTypeCell(LayoutCell):

    model_properties = [
        'abbreviation',
        'description',
        'name',
        'registration_end_days',
        'registration_start_days',
        'secret_voting_possible',
        'voting_days',
        'voting_type',
    ]

    def show_edit_button(self):
        return self.options.get('show_edit_button'
                                ) and self._request.permitted_for_current_user(self._model, EditPermission)


@App.cell(VotingPhaseTypes, 'new')
class NewVotingPhaseTypeCell(NewFormCell):

    def _prepare_form_for_render(self):
        items = items_for_voting_phase_type_select_widgets(self._model)
        self.set_form_data({"secret": True})
        self._form.prepare_for_render(items)


@App.cell(VotingPhaseType, 'edit')
class EditVotingPhaseTypeCell(EditFormCell):

    def _prepare_form_for_render(self):
        form_data = self._model.to_dict()
        self.set_form_data(form_data)
        items = items_for_voting_phase_type_select_widgets(self._model)
        self._form.prepare_for_render(items)
