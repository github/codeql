import csharp
import semmle.code.csharp.controlflow.Guards

from DereferenceableExpr de, AbstractValue v, boolean isNull
select de.getANullCheck(v, isNull), de, v, isNull
