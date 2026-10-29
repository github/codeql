import csharp
import semmle.code.csharp.frameworks.Format

from Callable c, StringFormatItemParameter p
where c = p.getCallable()
select c.getDeclaringType().toStringWithTypes(), c.toStringWithTypes(), p.getName()
