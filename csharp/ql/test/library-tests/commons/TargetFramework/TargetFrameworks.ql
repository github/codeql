import csharp
import semmle.code.csharp.commons.TargetFramework

from TargetFrameworkAttribute target
select target, target.getFrameworkType(), target.getFrameworkVersion()
