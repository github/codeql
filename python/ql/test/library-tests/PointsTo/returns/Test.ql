import python
private import LegacyPointsTo

from PyFunctionObject f
select f.toString(), f.getAnInferredReturnType().toString()
