
import csharp
import semmle.code.csharp.frameworks.System

from MethodCall call
where call.getTarget().hasFullyQualifiedName("System.IO", "Path", "Combine")
select call, "Path.Combine may silently discard its initial arguments if the latter are absolute paths. Use Path.Join to consistently join them."