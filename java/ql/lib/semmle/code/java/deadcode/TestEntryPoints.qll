import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.Cucumber
import semmle.code.java.deadcode.frameworks.FitNesseEntryPoints
import semmle.code.java.frameworks.Mockito
import semmle.code.java.UnitTests

/**
 * A test method, suite, or an associated setup/teardown method.
 */
class TestMethodEntry extends CallableEntryPoint {
  TestMethodEntry() {
    this instanceof TestMethod and
    // Ignored tests are not run
    not this instanceof JUnitIgnoredMethod
    or
    this instanceof JUnit3TestSuite
    or
    exists(AnnotationType a | a = this.getAnAnnotation().getType() |
      a.hasQualifiedName("org.junit.runners", "Parameterized$Parameters") and
      this.getDeclaringType() instanceof ParameterizedJUnitTest
    )
  }
}

/**
 * Methods that are called before or after tests.
 */
class BeforeOrAfterEntry extends CallableEntryPoint {
  BeforeOrAfterEntry() {
    this.getAnAnnotation() instanceof TestNGBeforeAnnotation or
    this.getAnAnnotation() instanceof TestNGAfterAnnotation or
    this.getAnAnnotation() instanceof BeforeAnnotation or
    this.getAnAnnotation() instanceof BeforeClassAnnotation or
    this.getAnAnnotation() instanceof AfterAnnotation or
    this.getAnAnnotation() instanceof AfterClassAnnotation
  }
}

/**
 * A method in a test class that is either a JUnit theory, or a method providing data points for a theory.
 */
class JUnitTheories extends CallableEntryPoint {
  JUnitTheories() {
    exists(AnnotationType a |
      a = this.getAnAnnotation().getType() and
      this.getDeclaringType() instanceof JUnitTheoryTest
    |
      a.hasQualifiedName("org.junit.experimental.theories", "Theory") or
      a.hasQualifiedName("org.junit.experimental.theories", "DataPoint") or
      a.hasQualifiedName("org.junit.experimental.theories", "DataPoints")
    )
  }
}

/**
 * A field which provides a JUnit `DataPoint` for a theory.
 */
class JUnitDataPointField extends ReflectivelyReadField {
  JUnitDataPointField() {
    exists(AnnotationType a | a = this.getAnAnnotation().getType() |
      (
        a.hasQualifiedName("org.junit.experimental.theories", "DataPoint") or
        a.hasQualifiedName("org.junit.experimental.theories", "DataPoints")
      ) and
      this.getDeclaringType() instanceof JUnitTheoryTest
    )
  }
}

/**
 * Any types used as a category in a JUnit `@Category` annotation should be considered live.
 */
class JUnitCategory extends WhitelistedLiveClass {
  JUnitCategory() { exists(JUnitCategoryAnnotation ca | ca.getACategory() = this) }
}

/**
 * A listener that will be reflectively constructed by TestNG.
 */
class TestNGReflectivelyConstructedListener extends ReflectivelyConstructedClass instanceof TestNGListenerImpl
{
  // Consider any class that implements a TestNG listener interface to be live. Listeners can be
  // specified on the command line, in `testng.xml` files and in Ant build files, so it is safest
  // to assume that all such listeners are live.
}

/**
 * A `@DataProvider` TestNG method which is live because it is accessed by at least one test.
 */
class TestNGDataProvidersEntryPoint extends CallableEntryPoint {
  TestNGDataProvidersEntryPoint() {
    exists(TestNGTestMethod method | this = method.getADataProvider())
  }
}

/**
 * A `@Factory` TestNG method or constructor which is live.
 */
class TestNGFactoryEntryPoint extends CallableEntryPoint instanceof TestNGFactoryCallable { }

class TestRefectivelyConstructedClass extends ReflectivelyConstructedClass {
  TestRefectivelyConstructedClass() {
    this.getAnAncestor().getACallable() instanceof TestMethodEntry
  }
}

class RunWithReflectivelyConstructedClass extends ReflectivelyConstructedClass {
  RunWithReflectivelyConstructedClass() {
    exists(AnnotationType a | a = this.getAnAnnotation().getType() |
      a.hasQualifiedName("org.junit.runner", "RunWith")
    )
  }
}

/**
 * Callables called by Mockito when performing injection.
 */
class MockitoCalledByInjection extends CallableEntryPoint {
  MockitoCalledByInjection() {
    exists(MockitoInjectedField field | this = field.getAnInvokedCallable())
    or
    exists(MockitoSpiedField spyField |
      spyField.isConstructed() and
      this = spyField.getType().(RefType).getAConstructor() and
      this.getNumberOfParameters() = 0
    )
  }
}

/**
 * Mock fields that are read by Mockito when performing injection.
 */
class MockitoReadField extends ReflectivelyReadField {
  MockitoReadField() { this.(MockitoMockedField).isReferencedByInjection() }
}

/**
 * A class constructed by Cucumber.
 */
class CucumberConstructedClass extends ReflectivelyConstructedClass {
  CucumberConstructedClass() {
    this instanceof CucumberStepDefinitionClass or
    this.getAnAncestor() instanceof CucumberJava8Language
  }

  override Callable getALiveCallable() {
    // Consider any constructor to be live - Cucumber calls a runtime-specified dependency
    // injection framework (possibly an in-built one) to construct these instances, so any
    // constructor could be called.
    result = this.getAConstructor()
  }
}

/**
 * A "step definition" that may be called by Cucumber when executing an acceptance test.
 */
class CucumberStepDefinitionEntryPoint extends CallableEntryPoint instanceof CucumberStepDefinition {
}
