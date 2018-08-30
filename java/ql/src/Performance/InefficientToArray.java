class Company {
	private List<Customer> customers = ...;
	
	public Customer[] getCustomerArray() {
		// AVOID: Inefficient call to 'toArray' with zero-length argument
		return customers.toArray(new Customer[0]);
	}
}

class Company {
	private List<Customer> customers = ...;
	
	public Customer[] getCustomerArray() {
		// GOOD: More efficient call to 'toArray' with argument that is big enough to store the list
		return customers.toArray(new Customer[customers.size()]);
	}
}

class Company {
	private static final Customer[] NO_CUSTOMERS = new Customer[0];
	
	private List<Customer> customers = ...;

	public Customer[] getCustomerArray() {
		// GOOD: Reuse same zero-length array on every invocation
		return customers.toArray(NO_CUSTOMERS);
	}
}