import cpp
import semmle.code.cpp.commons.NullTermination

from VariableAccess va
where variableMustBeNullTerminated(va)
select va
