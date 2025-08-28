/**
 * @id java/excessive-public-method-mocking
 * @previous-id java/mocking-all-non-private-methods-means-unit-test-is-too-big
 * @name Mocking all public methods of a class may indicate the unit test is testing too much
 * @description Mocking all public methods provided by a class might indicate the unit test
 *              aims to test too many things.
 * @kind problem
 * @precision high
 * @problem.severity recommendation
 * @tags quality
 *       maintainability
 *       readability
 */

import java

/**
 * A call to Mockito's `mock` method.
 */
class MockitoMockCall extends MethodCall {
  MockitoMockCall() { this.getMethod().hasQualifiedName("org.mockito", "Mockito", "mock") }

  /**
   * Gets the type that this call intends to mock. For example:
   * ```java
   * EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class);
   * ```
   * This predicate gets the class `EmployeeRecord` in the above example.
   */
  Type getMockedType() { result = this.getAnArgument().(TypeLiteral).getReferencedType() }
}

/**
 * A method call that mocks a target method in a JUnit test. For example:
 * ```java
 * EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class);
 * when(employeeRecordMock.add(sampleEmployee)).thenReturn(0); // Mocked EmployeeRecord.add
 * doReturn(0).when(employeeRecordMock).add(sampleEmployee);   // Mocked EmployeeRecord.add
 * ```
 * This class captures the call to `add` which mocks the equivalent method of the class `EmployeeRecord`.
 */
class MockitoMockingMethodCall extends MethodCall {
  MockitoMockCall mockCall;

  MockitoMockingMethodCall() {
    /* 1. The qualifier originates from the mock call. */
    this.getQualifier().getControlFlowNode().getAPredecessor+() = mockCall.getControlFlowNode() and
    /* 2. The mocked method can be found in the class being mocked with the mock call. */
    mockCall.getMockedType().(ClassOrInterface).getAMethod() = this.getMethod()
  }

  /**
   * Gets the call to Mockito's `mock` from which the qualifier, the mocked object, originates.
   */
  MockitoMockCall getMockitoMockCall() { result = mockCall }
}

/*
 * The following from-where-select embodies this pseudocode:
 * - Find a JUnit4TestMethod which:
 *   - for a class that it mocks with a call to `mock`,
 *     - for all methods that the class has, there is a method that this test method mocks.
 */

from JUnit4TestMethod testMethod, ClassOrInterface mockedClassOrInterface
where
  exists(MockitoMockCall mockCall |
    mockCall.getEnclosingCallable() = testMethod and
    mockedClassOrInterface = mockCall.getMockedType() and
    // Only flag classes with multiple public methods (2 or more)
    strictcount(Method m | m = mockedClassOrInterface.getAMethod() and m.isPublic()) > 1 and
    forex(Method method | method = mockedClassOrInterface.getAMethod() and method.isPublic() |
      exists(MockitoMockingMethodCall mockedMethod |
        mockedMethod.getMockitoMockCall() = mockCall and
        mockedMethod.getMethod() = method
      )
    )
  )
select testMethod, "This test method mocks all public methods of a $@.", mockedClassOrInterface,
  "class or an interface"
