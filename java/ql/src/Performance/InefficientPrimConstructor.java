public class Account {
	private Integer balance;
	public Account(Integer startingBalance) {
		this.balance = startingBalance;
	}
}

public class BankManager {
	public void openAccount(Customer c) {
		...
		// AVOID: Inefficient primitive constructor
		accounts.add(new Account(new Integer(0)));
		// GOOD: Use 'valueOf'
		accounts.add(new Account(Integer.valueOf(0)));
		// GOOD: Rely on autoboxing
		accounts.add(new Account(0));
	}
}