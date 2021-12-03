import csharp
import semmle.code.csharp.commons.TargetFramework

from TargetFrameworkAttribute target, Class c
where target.hasElement(c) and target.fromSource()
select c, target
