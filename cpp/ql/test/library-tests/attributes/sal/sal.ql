import cpp

predicate argsOrPlaceholder(Attribute a, int index, int start_line, string name, string value) {
  if exists(a.getAnArgument())
  then
    exists(AttributeArgument arg | arg = a.getAnArgument() |
      index = arg.getIndex() and
      start_line = arg.getLocation().getStartLine() and
      name = arg.getName() and
      value = arg.getValueText()
    )
  else (
    index = -1 and
    start_line = a.getLocation().getStartLine() and
    name = "" and
    value = ""
  )
}

from Parameter p, Attribute a, int arg_index, int arg_line, string arg_name, string arg_value
where
  a = p.getAnAttribute() and
  argsOrPlaceholder(a, arg_index, arg_line, arg_name, arg_value)
select arg_line, p, a, arg_index, arg_name, arg_value
