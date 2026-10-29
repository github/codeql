public class Customer {
	private static List<Customer> customers;
	public void initialize() {
		// AVOID: Static field is written to by instance method.
		customers = new ArrayList<Customer>();
		register();
	}
	public static void add(Customer c) {
		customers.add(c);
	}
}

// ...
public class Department {
	public void addCustomer(String name) {
		Customer c = new Customer(n);
		// The following call overwrites the list of customers
		// stored in 'Customer' (see above).
		c.initialize();
		Customer.add(c);
	}
}
