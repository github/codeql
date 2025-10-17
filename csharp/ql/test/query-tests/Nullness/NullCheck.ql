import csharp
import semmle.code.csharp.controlflow.Guards

from DereferenceableExpr de
select de.getANullCheck(_, true), de
