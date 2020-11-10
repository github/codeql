import csharp
import semmle.code.csharp.frameworks.Test

from Element e, string type, string framework
where
  (
    framework = e.(TestClass).getAQlClass() and type = "TestClass"
    or
    framework = e.(TestMethod).getAQlClass() and type = "TestMethod"
  ) and
  not framework = "NonNestedType" and
  not framework = "SourceDeclarationType" and
  not framework = "SourceDeclarationCallable" and
  not framework = "SourceDeclarationMethod" and
  not framework = "NonConstructedMethod" and
  not framework = "RuntimeInstanceMethod" and
  not framework = "SummarizableMethod"
select e, type, framework
