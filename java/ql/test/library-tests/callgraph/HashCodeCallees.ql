import default

from HashCodeMethod hm, Callable callee
where callee = hm.getACallee()
select hm.getDeclaringType() + "." + hm, callee.getDeclaringType() + "." + callee
