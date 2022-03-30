import java.util.concurrent.locks.ReentrantLock;

class ReentrantLockOrder {
	private int primaryAccountBalance;
	private final ReentrantLock primaryLock = new ReentrantLock();
	private int savingsAccountBalance;
	private final ReentrantLock savingsLock = new ReentrantLock();

	public boolean transferToSavings(int amount) {
		try {
			primaryLock.lock();
			savingsLock.lock();
			if (amount>0 && primaryAccountBalance>=amount) {
				primaryAccountBalance -= amount;
				savingsAccountBalance += amount;
				return true;
			}
		} finally {
			savingsLock.unlock();
			primaryLock.unlock();
		}
		return false;
	}
	public boolean transferToPrimary(int amount) {
		// AVOID: lock order is different from "transferToSavings"
		// and may result in deadlock
		try {
			savingsLock.lock();
			primaryLock.lock();
			if (amount>0 && primaryAccountBalance>=amount) {
				primaryAccountBalance -= amount;
				savingsAccountBalance += amount;
				return true;
			}
		} finally {
			primaryLock.unlock();
			savingsLock.unlock();
		}
		return false;
	}
}
