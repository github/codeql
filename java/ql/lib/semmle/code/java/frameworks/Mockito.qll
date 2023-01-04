/**
 * Provides classes and predicates for identifying use of the Mockito mocking framework.
 *
 * QL classes are provided for detecting uses of Mockito annotations on fields.
 */

import java

/**
 * A `verify` method in a mockito class.
 */
class MockitoVerifyMethod extends Method {
  MockitoVerifyMethod() {
    this.getDeclaringType().getPackage().getName().matches("org.mockito%") and
    this.hasName("verify")
  }
}

/**
 * A MethodAccess which is called as part of a Mockito verification setup.
 */
class MockitoVerifiedMethodAccess extends MethodAccess {
  MockitoVerifiedMethodAccess() {
    this.getQualifier().(MethodAccess).getMethod() instanceof MockitoVerifyMethod
  }
}

/**
 * A type that can be mocked by Mockito.
 */
class MockitoMockableType extends ClassOrInterface {
  MockitoMockableType() {
    // Any class or interface that is not final.
    not this.(Class).isFinal()
  }
}

/**
 * The `MockitoAnnotations.initMock(Object)` method, which can be called to initialise Mockito
 * annotated fields on the given object.
 */
class MockitoInitMocks extends Method {
  MockitoInitMocks() {
    this.getDeclaringType().hasQualifiedName("org.mockito", "MockitoAnnotations") and
    this.hasName("initMocks")
  }
}

/**
 * A class where the Mockito annotated fields have been initialized.
 */
class MockitoInitedTest extends Class {
  MockitoInitedTest() {
    // Tests run with the Mockito runner.
    exists(RunWithAnnotation a | a = this.getAnAncestor().getAnAnnotation() |
      a.getRunner().(RefType).hasQualifiedName("org.mockito.junit", "MockitoJUnitRunner")
      or
      // Deprecated styles.
      a.getRunner().(RefType).hasQualifiedName("org.mockito.runners", "MockitoJUnitRunner")
      or
      a.getRunner().(RefType).hasQualifiedName("org.mockito.runners", "MockitoJUnit44Runner")
    )
    or
    // Call to `MockitoAnnotations.initMocks()`, either by the constructor or by a `@Before` method.
    exists(MockitoInitMocks initMocks |
      this.getAConstructor().calls*(initMocks)
      or
      exists(Method m |
        m = this.getAnAncestor().getAMethod() and
        (
          m.hasAnnotation("org.junit", "Before") or
          m.hasAnnotation("org.testng.annotations", "BeforeMethod")
        )
      |
        m.calls*(initMocks)
      )
      or
      exists(MethodAccess call | call.getCallee() = initMocks |
        call.getArgument(0).getType() = this
      )
    )
  }
}

/**
 * A Mockito annotation.
 */
class MockitoAnnotation extends Annotation {
  MockitoAnnotation() {
    this.getType().getPackage().hasName("org.mockito") or
    this.getType().getPackage().getName().matches("org.mockito.%")
  }
}

/**
 * Only one of these annotations should be applied to a field.
 */
class MockitoExclusiveAnnotation extends MockitoAnnotation {
  MockitoExclusiveAnnotation() {
    this.getType().hasQualifiedName("org.mockito", "Mock") or
    this.getType().hasQualifiedName("org.mockito", "MockitoAnnotations$Mock") or
    this.getType().hasQualifiedName("org.mockito", "InjectMocks") or
    this.getType().hasQualifiedName("org.mockito", "Spy") or
    this.getType().hasQualifiedName("org.mockito", "Captor")
  }
}

/**
 * A field which has a Mockito annotation.
 */
class MockitoAnnotatedField extends Field {
  MockitoAnnotatedField() { this.getAnAnnotation() instanceof MockitoAnnotation }

  /**
   * Holds if this field will be processed by Mockito.
   */
  predicate isValid() {
    // Mockito annotations are never parsed if the test isn't properly initialized.
    this.getDeclaringType() instanceof MockitoInitedTest and
    // There should only be one "exclusive" mockito annotation per field.
    count(this.getAnAnnotation().(MockitoExclusiveAnnotation)) = 1
  }
}

/**
 * A field annotated with the Mockito `@Mock` annotation, indicating the field will be mocked.
 */
class MockitoMockedField extends MockitoAnnotatedField {
  MockitoMockedField() {
    this.hasAnnotation("org.mockito", "Mock")
    or
    // Deprecated style.
    this.hasAnnotation("org.mockito", "MockitoAnnotations$Mock")
  }

  override predicate isValid() {
    super.isValid() and
    // The type must also be mockable, otherwise it will not be initialized.
    this.getType() instanceof MockitoMockableType
  }

  /**
   * Holds if this mock may be referenced by an `@InjectMocks` annotated field.
   */
  predicate isReferencedByInjection() {
    exists(MockitoInjectedField injectedField |
      injectedField.getDeclaringType() = this.getDeclaringType()
    |
      // A `@Mock` is injected if it is used in one of the invoked callables (constructor or
      // setter), or injected directly onto a field.
      this.getType().(RefType).getAnAncestor() =
        injectedField.getAnInvokedCallable().getAParamType() or
      this.getType().(RefType).getAnAncestor() = injectedField.getASetField().getType()
    )
  }
}

/**
 * A field annotated with `@InjectMocks`.
 */
class MockitoInjectedField extends MockitoAnnotatedField {
  MockitoInjectedField() { this.hasAnnotation("org.mockito", "InjectMocks") }

  override predicate isValid() {
    super.isValid() and
    (
      // If we need to initialize the field, it is only valid if the type is a `Class` that is not
      // local, is static if it is a nested class, and is not abstract.
      exists(this.getInitializer())
      or
      exists(Class c | c = this.getType() |
        not c.isLocal() and
        (this.getType() instanceof NestedClass implies c.(NestedClass).isStatic()) and
        not c.isAbstract()
      )
    ) and
    (
      // If neither of these is true, then mockito will fail to initialize this field.
      this.usingConstructorInjection() or
      this.usingPropertyInjection()
    )
  }

  /**
   * Holds if this field will be injected by constructor.
   *
   * Note: this does not include the no-arg constructor.
   */
  predicate usingConstructorInjection() {
    not exists(this.getInitializer()) and
    exists(this.getMockInjectedClass().getAMostMockableConstructor())
  }

  /**
   * Holds if this field will be injected by properties.
   *
   * Note: if the field is not initialized, property injection will also call the no-arg
   * constructor, in addition to any property.
   */
  predicate usingPropertyInjection() {
    not this.usingConstructorInjection() and
    (
      exists(this.getInitializer()) or
      exists(this.getMockInjectedClass().getNoArgsConstructor())
    )
  }

  /**
   * Gets the class that will be injected, if this field is valid.
   */
  MockitoMockInjectedClass getMockInjectedClass() { result = super.getType() }

  /**
   * Gets a callable invoked when injecting mocks into this field.
   */
  Callable getAnInvokedCallable() {
    exists(MockitoMockInjectedClass mockInjectedClass |
      // This is the type we are constructing/injecting.
      mockInjectedClass = this.getType()
    |
      if this.usingConstructorInjection()
      then
        // If there is no initializer for this field, and there is a most mockable constructor,
        // then we are doing a parameterized injection of mocks into a most mockable constructor.
        result = mockInjectedClass.getAMostMockableConstructor()
      else
        if this.usingPropertyInjection()
        then
          // We will call the no-arg constructor if the field wasn't initialized.
          not exists(this.getInitializer()) and
          result = mockInjectedClass.getNoArgsConstructor()
          or
          // Perform property injection into setter fields, but only where there exists a mock
          // that can be injected into the method. Otherwise, the setter method is never called.
          result = mockInjectedClass.getASetterMethod() and
          exists(MockitoMockedField mockedField |
            mockedField.getDeclaringType() = this.getDeclaringType() and
            mockedField.isValid()
          |
            // We make a simplifying assumption here - in theory, each mock can only be injected
            // once, but we instead assume that there are sufficient mocks to go around.
            mockedField.getType().(RefType).getAnAncestor() = result.getParameterType(0)
          )
        else
          // There's no instance, and no no-arg constructor we can call, so injection fails.
          none()
    )
  }

  /**
   * Gets a field that will be set when injecting mocks.
   *
   * Field injection only occurs if property injection and not constructor injection is used.
   */
  Field getASetField() {
    if this.usingPropertyInjection()
    then
      result = this.getMockInjectedClass().getASetField() and
      exists(MockitoMockedField mockedField |
        mockedField.getDeclaringType() = this.getDeclaringType() and
        mockedField.isValid()
      |
        // We make a simplifying assumption here - in theory, each mock can only be injected
        // once, but we instead assume that there are sufficient mocks to go around.
        mockedField.getType().(RefType).getAnAncestor() = result.getType()
      )
    else none()
  }
}

/**
 * A field annotated with the Mockito `@Spy` annotation.
 */
class MockitoSpiedField extends MockitoAnnotatedField {
  MockitoSpiedField() { this.hasAnnotation("org.mockito", "Spy") }

  override predicate isValid() {
    super.isValid() and
    (
      exists(this.getInitializer())
      or
      exists(Constructor c |
        c = this.getType().(RefType).getAConstructor() and c.getNumberOfParameters() = 0
      )
    )
  }

  /**
   * Holds if construction ever occurs.
   */
  predicate isConstructed() { not exists(this.getInitializer()) }
}

private int mockableParameterCount(Constructor constructor) {
  result =
    count(Parameter p |
      p = constructor.getAParameter() and p.getType() instanceof MockitoMockableType
    )
}

/**
 * A class which is referenced by an `@InjectMocks` field.
 */
library class MockitoMockInjectedClass extends Class {
  MockitoMockInjectedClass() {
    // There must be an `@InjectMock` field that has `this` as the type.
    exists(MockitoInjectedField injectedField | this = injectedField.getType())
  }

  /**
   * Find the constructor with the greatest number of mockable parameters.
   *
   * This constructor must have at least one parameter.
   *
   * Note: If there are multiple constructors with the greatest number of mockable parameters,
   * Mockito will call only one of them, but which one is dependent on the JVM...
   */
  Constructor getAMostMockableConstructor() {
    result = this.getAConstructor() and
    mockableParameterCount(result) = max(mockableParameterCount(this.getAConstructor())) and
    result.getNumberOfParameters() > 0
  }

  /**
   * Gets the no-args constructor for this class, if one exists.
   */
  Constructor getNoArgsConstructor() {
    result = this.getAConstructor() and result.getNumberOfParameters() = 0
  }

  /**
   * Gets a property setter method usable by Mockito.
   *
   * It must have a single parameter, begin with "set", and there must be an equivalent field that
   * it sets.
   */
  Method getASetterMethod() {
    result = this.getAMethod() and
    exists(MockitoSettableField settableField | result = settableField.getSetterMethod())
  }

  /**
   * Gets a field that is set by Mockito.
   *
   * A settable field is one that is neither static, nor final, and does not have an equivalent
   * setter method.
   */
  MockitoSettableField getASetField() {
    result = this.getAField() and
    not exists(result.getSetterMethod())
  }
}

/**
 * A field in a `MockitoMockInjectedClass` that can be set by mockito, either directly or indirectly
 * through a setter method.
 */
class MockitoSettableField extends Field {
  MockitoSettableField() {
    not this.isFinal() and
    not this.isStatic() and
    this.getDeclaringType() instanceof MockitoMockInjectedClass
  }

  /**
   * Gets the setter method for this field, if one exists.
   */
  Method getSetterMethod() {
    result.getDeclaringType() = this.getDeclaringType() and
    result.getName().toLowerCase() = "set" + this.getName().toLowerCase() and
    result.getNumberOfParameters() = 1 and
    // The type of the setter much match the type of the field.
    result.getParameterType(0) = this.getType()
  }
}

class MockitoMockMethod extends Method {
  MockitoMockMethod() {
    this.getDeclaringType().hasQualifiedName("org.mockito", "Mockito") and
    (this.hasName("mock") or this.hasName("verify"))
  }
}

class MockitoMockedObject extends Expr {
  MockitoMockedObject() {
    this.(MethodAccess).getMethod() instanceof MockitoMockMethod
    or
    this.(VarAccess).getVariable().getAnAssignedValue() instanceof MockitoMockedObject
    or
    exists(ReturnStmt ret |
      this.(MethodAccess).getMethod() = ret.getEnclosingCallable() and
      ret.getResult() instanceof MockitoMockedObject
    )
  }
}
