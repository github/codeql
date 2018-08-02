import cpp

from Struct s, Attribute a, string alignment
where a = s.getAnAttribute()
  and (alignment = a.getAnArgument().getValueInt().toString() or alignment = ((Struct)a.getAnArgument().getValueType()).getQualifiedName())
select a.getLocation().toString(), s.getQualifiedName(), alignment
