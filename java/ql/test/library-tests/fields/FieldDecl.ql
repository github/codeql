import default

from FieldDeclaration fd, int idx, Field f
where f = fd.getField(idx)
select fd, idx + "/" + fd.getNumField(), f
