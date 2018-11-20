import python

from ClassObject c
where c.getName() = "_ctypes._Pointer"
select c.toString(), c.getAnInferredType().toString()