import org.junit.Test;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.doReturn;

public class TestORM {
  /**
   * Test of form `when(mockedObject.methodToBeMocked()).thenReturn(someVal)`.
   */
  @Test
  public void compliant1() {
    Employee sampleEmployee = new Employee("John Doe");
    EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class); // COMPLIANT: Only some of the public methods belonging to the mocked object are used
    when(employeeRecordMock.add(sampleEmployee)).thenReturn(0); // Mocked EmployeeRecord.add
    when(employeeRecordMock.update(sampleEmployee, "Jane Doe")).thenReturn(0); // Mocked EmployeeRecord.update
  }

  /**
   * Test of form `doReturn(someVal).when(mockedObject).methodToBeMocked()`.
   */
  @Test
  public void compliant2() {
    Employee sampleEmployee = new Employee("John Doe");
    EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class); // COMPLIANT: Only some of the public methods belonging to the mocked object are used
    doReturn(0).when(employeeRecordMock).add(sampleEmployee); // Mocked EmployeeRecord.add
    doReturn(0).when(employeeRecordMock).get("John Doe"); // Mocked EmployeeRecord.get
    doReturn(0).when(employeeRecordMock).delete(sampleEmployee); // Mocked EmployeeRecord.delete
  }

  /**
   * Test of form `when(mockedObject.methodToBeMocked()).thenReturn(someVal)`.
   */
  @Test
  public void nonCompliant1() {
    Employee sampleEmployee = new Employee("John Doe");
    EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class); // NON_COMPLIANT: All public methods of the mocked object are used
    when(employeeRecordMock.add(sampleEmployee)).thenReturn(0); // Mocked EmployeeRecord.add
    when(employeeRecordMock.get("John Doe")).thenReturn(sampleEmployee); // Mocked EmployeeRecord.get
    when(employeeRecordMock.update(sampleEmployee, "Jane Doe")).thenReturn(0); // Mocked EmployeeRecord.update
    when(employeeRecordMock.delete(sampleEmployee)).thenReturn(0); // Mocked EmployeeRecord.delete
  }

  /**
   * Test of form `doReturn(someVal).when(mockedObject).methodToBeMocked()`.
   */
  @Test
  public void nonCompliant2() {
    Employee sampleEmployee = new Employee("John Doe");
    EmployeeRecord employeeRecordMock = mock(EmployeeRecord.class); // NON_COMPLIANT: All public methods of the mocked object are used
    doReturn(0).when(employeeRecordMock).add(sampleEmployee); // Mocked EmployeeRecord.add
    doReturn(0).when(employeeRecordMock).get("John Doe"); // Mocked EmployeeRecord.get
    doReturn(0).when(employeeRecordMock).update(sampleEmployee, "Jane Doe"); // Mocked EmployeeRecord.update
    doReturn(0).when(employeeRecordMock).delete(sampleEmployee); // Mocked EmployeeRecord.delete
  }
}
