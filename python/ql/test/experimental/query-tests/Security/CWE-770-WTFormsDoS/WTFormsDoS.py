from wtforms.validators import DataRequired, Length, Optional, Regexp
from wtforms.fields import StringField

class Bad():
    bad = StringField('bad', validators=[Optional()])

class Good():
    bad = StringField('bad', validators=[Optional(), Length(max=256, message=_('parameter too long.'))])

