## Overview

Mocking methods of a class is necessary for unit tests to run without overhead caused by expensive I/O operations. However, when a unit test ends up mocking all public methods of a class, it may indicate that the test is too complicated, possibly because it is trying to test multiple things at once. Such extensive mocking is likely a signal that the scope of the unit test is reaching beyond a single unit of functionality.

## Recommendation

It is best to contain the scope of a single unit test to a single unit of functionality. For example, a unit test may aim to test a series of data-transforming functions that depend on an ORM class. Even though the functions may be semantically related with one another, it is better to create a unit test for each function.

## Example

The following example mocks all methods of an ORM class named `EmployeeRecord`, and tests four functions against them. Since the scope of the unit test harbors all four of them, all of the methods provided by the class are mocked.

```java
public class EmployeeRecord {
  public int add(Employee employee) { ... }

  public Employee get(String name) { ... }

  public int update(Employee employee, String newName) { ... }

  public int delete(Employee employee) { ... }
}

public class TestORM {
  @Test
  public void nonCompliant() {
    Employee sampleEmployee = new Employee("John Doe");
    EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class);  // NON_COMPLIANT: Mocked class has all of its public methods used in the test
    when(employeeRecordMock.add(sampleEmployee)).thenReturn(0);                   // Mocked EmployeeRecord.add
    when(employeeRecordMock.get("John Doe")).thenReturn(sampleEmployee);          // Mocked EmployeeRecord.get
    when(employeeRecordMock.update(sampleEmployee, "Jane Doe")).thenReturn(0);    // Mocked EmployeeRecord.update
    when(employeeRecordMock.delete(sampleEmployee)).thenReturn(0);                // Mocked EmployeeRecord.delete
  }

  @Test
  public void compliant() {
    Employee sampleEmployee = new Employee("John Doe");
    EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class); // COMPLIANT: Only some of the public methods belonging to the mocked object are used
    when(employeeRecordMock.add(sampleEmployee)).thenReturn(0);                // Mocked EmployeeRecord.add
    when(employeeRecordMock.update(sampleEmployee, "Jane Doe")).thenReturn(0); // Mocked EmployeeRecord.update
  }

}
```

## Implementation Notes

JUnit provides two different ways of mocking a method call: `when(mockedObject.methodToMock(...)).thenReturn(...)` and `doReturn(...).when(mockedObject).methodToMock(...)`. Both forms are taken into account by the query.

## References

- Baeldung: [Best Practices for Unit Testing in Java](https://www.baeldung.com/java-unit-testing-best-practices).
