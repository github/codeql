/** Provides definitions related to the xUnit.net test framework. */

import csharp
import semmle.code.csharp.frameworks.Test

/** The `Xunit` namespace. */
class XUnitNamespace extends Namespace {
  XUnitNamespace() { this.hasQualifiedName("Xunit") }
}

/** An xUnit test attribute. */
class XUnitTestCaseAttribute extends Attribute {
  XUnitTestCaseAttribute() {
    exists(Class c |
      c = this.getType() and
      c.getNamespace() instanceof XUnitNamespace
    |
      c.hasName("FactAttribute")
      or
      c.hasName("TheoryAttribute")
    )
  }
}

/** An xUnit test class. */
class XUnitTestClass extends TestClass {
  XUnitTestClass() { this.getAMethod() instanceof XUnitTestMethod }
}

/** An xUnit test method. */
class XUnitTestMethod extends TestMethod {
  XUnitTestMethod() { this = any(XUnitTestCaseAttribute a).getTarget() }

  override predicate expectsException() { none() }
}

/**
 * A file that contains some xUnit annotations and is, hence, a test file.
 */
class XUnitTestFile extends TestFile {
  XUnitTestFile() {
    exists(XUnitTestMethod m | m.getFile() = this) or
    exists(XUnitTestClass c | c.getFile() = this)
  }
}
