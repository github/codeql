import cpp

from Class derived, Field field, int offset
where field.getAByteOffsetIn(derived) = offset
select derived.toString(), field.getDeclaringType().toString(), field.toString(), offset
