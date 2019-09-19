import cpp

from Function f, Attribute a, AttributeArgument arg
where
  a = f.getAnAttribute() and
  arg = a.getAnArgument()
select arg, f, a, arg.getValueText()
