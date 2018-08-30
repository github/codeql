class MethodAccessLockOrder {
	private Account primary = new Account();
	private Account savings = new Account();
	class Account {
		private int balance;

		public synchronized boolean transferFrom(Account malo, int amount) {
			int subtracted = malo.subtract(amount);
			if (subtracted == amount) {
				balance += subtracted;
				return true;
			}
			return false;
		}

		public synchronized int subtract(int amount) {
			if (amount>0 && balance>amount) {
				balance -= amount;
				return amount;
			}
			return 0;
		}

	}

	public boolean initiateTransfer(boolean fromSavings, int amount) {
		// AVOID: inconsistent lock order
		if (fromSavings) {
			primary.transferFrom(savings, amount);
		} else {
			savings.transferFrom(primary, amount);
		}
	}

}
