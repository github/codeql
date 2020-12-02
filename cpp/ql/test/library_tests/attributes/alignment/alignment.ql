import cpp

from Struct s, Attribute a, string alignment
where
  a = s.getAnAttribute() and
  (
    alignment = a.getAnArgument().getValueInt().toString() or
    alignment = a.getAnArgument().getValueType().(Struct).getQualifiedName()
  )
select a.getLocation().toString(), s.getQualifiedName(), alignment
