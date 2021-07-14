import csharp
import semmle.code.csharp.commons.TargetFramework

from TargetFrameworkAttribute target
where target.isNetCore() and target.fromSource()
select target
