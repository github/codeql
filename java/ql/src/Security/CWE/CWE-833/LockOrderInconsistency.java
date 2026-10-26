class Test {
	private int primaryAccountBalance;
	private Object primaryLock = new Object();
	private int savingsAccountBalance;
	private Object savingsLock = new Object();

	public boolean transferToSavings(int amount) {
		synchronized(primaryLock) {
			synchronized(savingsLock) {
				if (amount>0 && primaryAccountBalance>=amount) {
					primaryAccountBalance -= amount;
					savingsAccountBalance += amount;
					return true;
				}
			}
		}
		return false;
	}
	public boolean transferToPrimary(int amount) {
		// AVOID: lock order is different from "transferToSavings"
		// and may result in deadlock
		synchronized(savingsLock) {
			synchronized(primaryLock) {
				if (amount>0 && savingsAccountBalance>=amount) {
					savingsAccountBalance -= amount;
					primaryAccountBalance += amount;
					return true;
				}
			}
		}
		return false;
	}
}
