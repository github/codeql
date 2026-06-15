import csharp
import semmle.code.csharp.frameworks.system.diagnostics.CodeAnalysis

from Attributable element, ExperimentalAttribute attribute
where attribute = element.getAnAttribute() and attribute.fromSource()
select element, attribute, attribute.getId()
