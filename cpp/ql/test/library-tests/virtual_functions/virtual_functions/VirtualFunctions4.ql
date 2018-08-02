import cpp

from VirtualFunction f, string overriddenFunctionDeclaringType
where if exists(f.getAnOverriddenFunction().getDeclaringType())
      then overriddenFunctionDeclaringType = f.getAnOverriddenFunction().getDeclaringType().toString()
      else overriddenFunctionDeclaringType = "<none>"
select f,
       f.getDeclaringType(),
       count(f.getAnOverridingFunction()),
       count(f.getAnOverriddenFunction()),
       overriddenFunctionDeclaringType

