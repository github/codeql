import csharp
import semmle.code.csharp.frameworks.test.NUnit

from ValueSourceAttribute attribute
select attribute.getTarget(), attribute.getSourceMethod()
