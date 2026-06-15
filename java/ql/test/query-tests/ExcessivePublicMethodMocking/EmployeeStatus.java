/**
 * Simple class with a single public method to test the edge case.
 * When this single method is mocked, it means ALL public methods are mocked.
 */
public class EmployeeStatus {
    public String getStatus() {
        return "active";
    }
}
