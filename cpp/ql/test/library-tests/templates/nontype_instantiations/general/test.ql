import cpp

string maybeGetTemplateArgumentKind(Declaration d, int i) {
  (
    if exists(d.getTemplateArgumentKind(i))
    then result = d.getTemplateArgumentKind(i).toString()
    else result = "<none>"
  ) and
  i = [0 .. d.getNumberOfTemplateArguments()]
}

string maybeGetTemplateArgumentValue(Declaration d, int i) {
  (
    if exists(d.getTemplateArgument(i).(Expr).getValue())
    then result = d.getTemplateArgument(i).(Expr).getValue()
    else result = "<none>"
  ) and
  i = [0 .. d.getNumberOfTemplateArguments()]
}

from Declaration d, int i
where i >= 0 and i < d.getNumberOfTemplateArguments()
select d, i, maybeGetTemplateArgumentKind(d, i), d.getTemplateArgument(i),
  maybeGetTemplateArgumentValue(d, i)
