import cpp

from Type t, Attribute a, AttributeArgument arg
where
  a = t.getAnAttribute() and
  arg = a.getAnArgument()
select t, a, arg
