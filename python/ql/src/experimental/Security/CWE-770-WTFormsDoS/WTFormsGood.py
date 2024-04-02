class Good():
    bad = StringField('bad', validators=[Optional(), Length(max=256, message=_('parameter too long.'))])