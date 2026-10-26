import csharp
import semmle.code.csharp.frameworks.test.NUnit

from TestCaseSourceAttribute attribute
select attribute.getTarget(), attribute.getUnboundDeclaration()
