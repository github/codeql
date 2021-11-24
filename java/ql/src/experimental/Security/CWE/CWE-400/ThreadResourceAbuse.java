class SleepTest {
	public void test(int userSuppliedWaitTime) throws Exception {
		// BAD: no boundary check on wait time
		Thread.sleep(waitTime);

		// GOOD: enforce an upper limit on wait time
		if (waitTime > 0 && waitTime < 5000) {
			Thread.sleep(waitTime);
		}
	}
}
