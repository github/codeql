import cpp

from Class derived, Class base, int offset
where derived.getABaseClassByteOffset(base) = offset
select derived.toString(), base.toString(), offset
