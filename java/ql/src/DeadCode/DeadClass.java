public static void main(String[] args) {
	String firstName = /*...*/; String lastName = /*...*/;
	// Construct a customer
	Customer customer = new Customer();
	// Set important properties (but not the address)
	customer.setName(firstName, lastName);
	// Save the customer
	customer.save();
}

public class Customer {
	private Address address;
	// ...

	// This setter and getter are unused, and so may be deleted.
	public void addAddress(String line1, String line2, String line3) {
		address = new Address(line1, line2, line3);
	}
	public Address getAddress() { return address; }
}

/*
 * This class is only constructed from dead code, and may be deleted.
 */
public class Address {
	// ...
	public Address(String line1, String line2, String line3) {
		// ...
	}
}
