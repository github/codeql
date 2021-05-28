/** Provides definitions related to the NUnit test framework. */

import csharp
import semmle.code.csharp.frameworks.Test

/** A class that is an NUnit test fixture */
class NUnitFixture extends TestClass {
  NUnitFixture() {
    exists(Attribute fixture | fixture.getType().hasName("TestFixtureAttribute") |
      fixture.getTarget() = this
    )
    or
    this = any(NUnitTestMethod m).getDeclaringType()
  }
}

/** An NUnit test method. */
class NUnitTestMethod extends TestMethod {
  NUnitTestMethod() {
    exists(Attribute test |
      test.getType().hasName("TestAttribute") or
      test.getType().hasName("TestCaseAttribute")
    |
      test.getTarget() = this
    )
  }

  override predicate expectsException() {
    this.getAnAttribute().getType().hasName("ExpectedExceptionAttribute")
  }

  /**
   * Gets the expected exception type that this test will throw, if any.
   */
  RefType getExpectedException() {
    exists(Attribute expected |
      expected.getType().hasName("ExpectedExceptionAttribute") and
      expected.getTarget() = this
    |
      if expected.getArgument(0).getType() instanceof StringType
      then result.hasQualifiedName(expected.getArgument(0).getValue())
      else result = expected.getArgument(0).(TypeofExpr).getTypeAccess().getTarget()
    )
  }
}

/**
 * A file that contains some NUnit annotations and is, hence, a test file.
 */
class NUnitFile extends TestFile {
  NUnitFile() {
    exists(NUnitTestMethod m | m.getFile() = this) or
    exists(NUnitFixture c | c.getFile() = this)
  }
}

/** An attribute of type `NUnit.Framework.ValueSourceAttribute`. */
class ValueSourceAttribute extends Attribute {
  ValueSourceAttribute() { this.getType().hasQualifiedName("NUnit.Framework.ValueSourceAttribute") }

  /** Holds if the first argument is the target type. */
  private predicate typeSpecified() {
    this.getArgument(0).getType().(Class).hasQualifiedName("System.Type") and
    this.getArgument(1).getType() instanceof StringType
  }

  /** Gets the class where the value source method is declared. */
  ValueOrRefType getSourceType() {
    if this.typeSpecified()
    then result = this.getArgument(0).(TypeofExpr).getTypeAccess().getType()
    else exists(Method m | m.getAParameter() = this.getTarget() | result = m.getDeclaringType())
  }

  /** Gets the name of the value source method. */
  string getMethodName() {
    if this.typeSpecified()
    then result = this.getArgument(1).getValue()
    else result = this.getArgument(0).getValue()
  }

  /** Gets the method acting as the value source. */
  Method getSourceMethod() {
    result.getDeclaringType() = this.getSourceType() and
    result.getName() = this.getMethodName()
  }
}

/** An attribute of type `NUnit.Framework.TestCaseSourceAttribute`. */
class TestCaseSourceAttribute extends Attribute {
  TestCaseSourceAttribute() {
    this.getType().hasQualifiedName("NUnit.Framework.TestCaseSourceAttribute")
  }

  /** Holds if the first argument is the target type. */
  private predicate typeSpecified() {
    this.getArgument(0).getType().(Class).hasQualifiedName("System.Type") and
    this.getArgument(1).getType() instanceof StringType
  }

  /** Gets the class where the value is declared. */
  ValueOrRefType getSourceType() {
    if this.typeSpecified()
    then result = this.getArgument(0).(TypeofExpr).getTypeAccess().getType()
    else result = this.getTarget().(Method).getDeclaringType()
  }

  /** Gets the name of the value. */
  string getFieldName() {
    if this.typeSpecified()
    then result = this.getArgument(1).getValue()
    else result = this.getArgument(0).getValue()
  }

  /** Gets the declaration where the values are declared. */
  Declaration getUnboundDeclaration() {
    result.getDeclaringType() = this.getSourceType() and
    result.getName() = this.getFieldName()
  }
}

/** The `NUnit.Framework.Assert` class. */
class NUnitAssertClass extends Class {
  NUnitAssertClass() { this.hasQualifiedName("NUnit.Framework.Assert") }

  /** Gets a `Null(object, ...)` method. */
  Method getANullMethod() {
    result.getDeclaringType() = this and
    result.hasName("Null")
  }

  /** Gets an `IsNull(object, ...)` method. */
  Method getAnIsNullMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNull")
  }

  /** Gets a `NotNull(object, ...)` method. */
  Method getANotNullMethod() {
    result.getDeclaringType() = this and
    result.hasName("NotNull")
  }

  /** Gets an `IsNotNull(object, ...)` method. */
  Method getAnIsNotNullMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsNotNull")
  }

  /** Gets a `True(bool, ...)` method. */
  Method getATrueMethod() {
    result.getDeclaringType() = this and
    result.hasName("True")
  }

  /** Gets an `IsTrue(bool, ...)` method. */
  Method getAnIsTrueMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsTrue")
  }

  /** Gets a `False(bool, ...)` method. */
  Method getAFalseMethod() {
    result.getDeclaringType() = this and
    result.hasName("False")
  }

  /** Gets an `IsFalse(bool, ...)` method. */
  Method getAnIsFalseMethod() {
    result.getDeclaringType() = this and
    result.hasName("IsFalse")
  }

  /** Gets a `That(...)` method. */
  Method getAThatMethod() {
    result.getDeclaringType() = this and
    result.hasName("That")
  }
}

/** The `NUnit.Framework.AssertionException` class. */
class AssertionExceptionClass extends Class {
  AssertionExceptionClass() { this.hasQualifiedName("NUnit.Framework.AssertionException") }
}
