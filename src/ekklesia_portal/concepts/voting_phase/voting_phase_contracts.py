from colander import Length
from deform import Button
from deform.widget import SelectWidget, TextAreaWidget
from ekklesia_common.contract import Form, Schema, bool_property, date_property, enum_property, int_property, json_property, string_property
from ekklesia_common.translation import _

from ekklesia_portal.enums import VotingStatus


class VotingPhaseSchema(Schema):
    name = string_property(title=_('name'), validator=Length(max=23), missing='')
    title = string_property(title=_('title'), validator=Length(max=160), missing='')
    target = date_property(title=_('target'), missing=None)
    status = enum_property(VotingStatus, title=_('voting_status'))
    department_id = int_property(title=_('department'))
    phase_type_id = int_property(title=_('voting_phase_type'))
    secret = bool_property(title=_('secret_voting_possible'), description=_('secret_voting_possible_description'), missing=False)
    registration_start_days = int_property(title=_('registration_start_days'), description=_('registration_start_days_description'), missing=None)
    registration_end_days = int_property(title=_('registration_end_days'), description=_('registration_end_days_description'), missing=None)
    voting_days = int_property(title=_('voting_days'), description=_('voting_days_description'), missing=None)
    description = string_property(title=_('description'), validator=Length(max=65536), missing='')
    voting_module_data = json_property(title=_('voting_module_data'), missing={})


class VotingPhaseForm(Form):

    def __init__(self, request, action):
        super().__init__(VotingPhaseSchema(), request, action, buttons=[Button(title=_("submit"))])

    def prepare_for_render(self, items_for_selects):
        widgets = {
            'title': TextAreaWidget(rows=2),
            'description': TextAreaWidget(rows=8),
            'status': SelectWidget(values=items_for_selects['status']),
            'phase_type_id': SelectWidget(values=items_for_selects['phase_type']),
            'department_id': SelectWidget(values=items_for_selects['department'])
        }
        self.set_widgets(widgets)
