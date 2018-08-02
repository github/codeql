import csharp
import semmle.code.csharp.commons.TargetFramework

from TargetFrameworkAttribute target, Class c
where target.hasElement(c)
select c, target
