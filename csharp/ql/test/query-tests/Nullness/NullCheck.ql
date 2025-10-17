import csharp
import semmle.code.csharp.controlflow.Guards

from DereferenceableExpr de, Guards::Guard reason
where de.guardSuggestsMaybeNull(reason)
select reason, de
