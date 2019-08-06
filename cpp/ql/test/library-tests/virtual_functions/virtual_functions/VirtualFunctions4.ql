import cpp

from VirtualFunction f
select
	f,
	f.getDeclaringType(),
	concat(f.getAnOverridingFunction().getDeclaringType().toString(), ", "),
	concat(f.getAnOverriddenFunction().getDeclaringType().toString(), ", ")
