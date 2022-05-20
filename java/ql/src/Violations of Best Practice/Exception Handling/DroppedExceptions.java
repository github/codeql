// Dropped exception, with no information on whether 
// the exception is expected or not
synchronized void waitIfAutoSyncScheduled() {
	try {
		while (isAutoSyncScheduled) {
			this.wait(1000);
		}
	} catch (InterruptedException e) {
	}
}