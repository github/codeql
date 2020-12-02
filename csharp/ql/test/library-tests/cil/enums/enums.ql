import semmle.code.cil.Types

from Enum e
select e.getQualifiedName(), e.getUnderlyingType().toStringWithTypes()
