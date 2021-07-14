import csharp
import semmle.code.csharp.commons.TargetFramework

from TargetFrameworkAttribute target
where target.fromSource()
select target, target.getFrameworkType(), target.getFrameworkVersion()
