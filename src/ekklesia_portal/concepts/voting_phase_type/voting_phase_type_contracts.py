from colander import Length
from deform import Button
from deform.widget import Select2Widget, TextAreaWidget, HiddenWidget
from ekklesia_common.contract import Schema, Form, bool_property, int_property, string_property, enum_property
from ekklesia_common.translation import _

from ekklesia_portal.enums import VotingType


class VotingPhaseTypeSchema(Schema):
    name = string_property(title=_('name'), validator=Length(max=255))
    abbreviation = string_property(title=_('abbreviation'), validator=Length(max=6))
    voting_type = enum_property(VotingType, title=_('voting_type'))
    registration_start_days = int_property(title=_('registration_start_days'), description=_('registration_start_days_description'), missing=None)
    registration_end_days = int_property(title=_('registration_end_days'), description=_('registration_end_days_description'), missing=None)
    voting_days = int_property(title=_('voting_days'), description=_('voting_days_description'), missing=None)
    secret_voting_possible = bool_property(title=_('secret_voting_possible'), description=_('secret_voting_default_description'), missing=False)
    description = string_property(title=_('description'), validator=Length(max=2000), missing='')


class VotingPhaseTypeForm(Form):

    def __init__(self, request, action):
        super().__init__(VotingPhaseTypeSchema(), request, action, buttons=[Button(title=_("submit"))])

    def prepare_for_render(self, items_for_selects):
        widgets = {
            'secret_voting_possible': HiddenWidget(),
            'voting_type': Select2Widget(values=items_for_selects['voting_type']),
            'description': TextAreaWidget(rows=8),
        }
        self.set_widgets(widgets)
