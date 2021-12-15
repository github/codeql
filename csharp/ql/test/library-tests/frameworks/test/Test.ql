import csharp
import semmle.code.csharp.frameworks.Test

query predicate testClass(TestClass c) { any() }

query predicate testMethod(TestMethod m) { any() }
