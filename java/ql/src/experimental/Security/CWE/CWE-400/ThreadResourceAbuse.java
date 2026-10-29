class SleepTest {
	public void test(int userSuppliedWaitTime) throws Exception {
		// BAD: no boundary check on wait time
		Thread.sleep(userSuppliedWaitTime);

		// GOOD: enforce an upper limit on wait time
		if (userSuppliedWaitTime > 0 && userSuppliedWaitTime < 5000) {
			Thread.sleep(userSuppliedWaitTime);
		}
	}
}
