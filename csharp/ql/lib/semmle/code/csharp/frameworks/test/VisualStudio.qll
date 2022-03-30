/** Provides definitions related to the Microsoft Visual Studio Unit Testing Framework. */

import csharp
import semmle.code.csharp.frameworks.Test

/** The `Microsoft.VisualStudio.TestTools.UnitTesting` namespace. */
class VSTestNamespace extends Namespace {
  VSTestNamespace() { this.hasQualifiedName("Microsoft.VisualStudio.TestTools.UnitTesting") }
}

/** A class that contains test methods. */
class VSTestClass extends TestClass {
  VSTestClass() {
    exists(Attribute a, Class c |
      c = a.getType() and
      c.getNamespace() instanceof VSTestNamespace and
      c.hasName("TestClassAttribute") and
      a.getTarget() = this
    )
    or
    exists(VSTestMethod m | m.getDeclaringType() = this)
  }
}

/** A Visual Studio test method. */
class VSTestMethod extends TestMethod {
  VSTestMethod() {
    exists(Attribute a, Class c |
      c = a.getType() and
      c.getNamespace() instanceof VSTestNamespace and
      c.hasName("TestMethodAttribute") and
      a.getTarget() = this
    )
  }

  override predicate expectsException() { none() }
}

/**
 * A file that contains some Visual Studio Unit Testing Framework annotations and is,
 * hence, a test file.
 */
class VSTestFile extends TestFile {
  VSTestFile() {
    exists(VSTestMethod m | m.getFile() = this) or
    exists(VSTestClass c | c.getFile() = this)
  }
}

/** The `Microsoft.VisualStudio.TestTools.UnitTesting.Assert` class. */
class VSTestAssertClass extends Class {
  VSTestAssertClass() {
    this.getNamespace() instanceof VSTestNamespace and
    this.isStatic() and
    this.hasName("Assert")
  }

  /** Gets an `IsNull(object, ...)` method. */
  Method getIsNullMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNull") and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof VoidType
  }

  /** Gets an `IsNotNull(object, ...)` method. */
  Method getIsNotNullMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNotNull") and
    result.getParameter(0).getType() instanceof ObjectType and
    result.getReturnType() instanceof VoidType
  }

  /** Gets an `void IsTrue(bool, ...)` method. */
  Method getIsTrueMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsTrue") and
    result.getParameter(0).getType() instanceof BoolType and
    result.getReturnType() instanceof VoidType
  }

  /** Gets an `IsFalse(bool, ...)` method. */
  Method getIsFalseMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsFalse") and
    result.getParameter(0).getType() instanceof BoolType and
    result.getReturnType() instanceof VoidType
  }
}

/** The `Microsoft.VisualStudio.TestTools.UnitTesting.AssertFailedException` class. */
class AssertFailedExceptionClass extends Class {
  AssertFailedExceptionClass() {
    this.getNamespace() instanceof VSTestNamespace and
    this.hasName("AssertFailedException")
  }
}
