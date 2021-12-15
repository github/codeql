/*
 * This class is dead because it is never constructed, and the instance methods are not
 * called.
 */
public class CustomerActions {
	public CustomerActions() {
	}

	// This method is never called,
	public Action createAddCustomerAction () {
		return new AddCustomerAction();
	}

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
