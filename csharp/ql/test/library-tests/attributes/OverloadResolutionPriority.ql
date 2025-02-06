import csharp
import semmle.code.csharp.frameworks.system.runtime.CompilerServices

from
  Attributable element, SystemRuntimeCompilerServicesOverloadResolutionPriorityAttribute attribute
where attribute = element.getAnAttribute() and attribute.fromSource()
select element, attribute, attribute.getPriority()
