// This class is now live - it is used as a namespace class
public class CustomerActions {
	/*
	 * This constructor is suppressing construction of this class, so is not considered
	 * dead.
	 */
	private CustomerActions() { }
	// These two are used directly
	public static class AddCustomerAction extends Action { /* ... */ }
	public static class RemoveCustomerAction extends Action { /* ... */ }
}

public static void main(String[] args) {
	// Construct the actions directly
	Action action = new CustomerActions.AddCustomerAction();
	action.run();
	Action action = new CustomerActions.RemoveCustomerAction();
	action.run();
}
