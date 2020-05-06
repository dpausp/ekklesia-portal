from colander import Length
from deform.widget import TextAreaWidget
from ekklesia_common.contract import Schema, Form, string_property
from ekklesia_common.translation import _


class CustomizableTextSchema(Schema):
    name = string_property(title=_('name'), validator=Length(min=3, max=255))
    lang = string_property(title=_('lang'), validator=Length(min=2, max=16))
    text = string_property(title=_('text'), missing='')
    permissions = string_property(title=_('permissions'), missing='{}')


class CustomizableTextForm(Form):

    def __init__(self, request, action):
        super().__init__(CustomizableTextSchema(), request, action, buttons=("submit", ))

    def prepare_for_render(self):
        widgets = {
            'text': TextAreaWidget(rows=12)
        }
        self.set_widgets(widgets)
