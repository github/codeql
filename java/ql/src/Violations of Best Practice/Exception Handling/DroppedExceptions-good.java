// Exception is passed to 'ignore' method with a comment
synchronized void waitIfAutoSyncScheduled() {
	try {
		while (isAutoSyncScheduled) {
			this.wait(1000);
		}
	} catch (InterruptedException e) {
		Exceptions.ignore(e, "Expected exception. The file cannot be synchronized yet.");
	}
}