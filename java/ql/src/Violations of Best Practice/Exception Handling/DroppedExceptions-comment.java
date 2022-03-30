synchronized void waitIfAutoSyncScheduled() {
	try {
		while (isAutoSyncScheduled) {
			this.wait(1000);
		}
	} catch (InterruptedException e) {
		// Expected exception. The file cannot be synchronized yet.
	}
}