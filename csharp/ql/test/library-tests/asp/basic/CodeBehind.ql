import csharp
import semmle.code.asp.AspNet

from PageDirective f
select f, f.getInheritedType()
