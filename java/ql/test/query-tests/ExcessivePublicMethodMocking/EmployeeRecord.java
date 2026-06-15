/**
 * Sample ORM class for the type `Employee`.
 */
public class EmployeeRecord {
  public int add(Employee employee) {
    return 1;
  }

  public Employee get(String name) {
    return new Employee("Sample");
  }

  public int update(Employee employee, String newName) {
    return 1;
  }

  public int delete(Employee employee) {
    return 1;
  }

  private void f() { }

  private void g() { }

  private void h() { }
}
