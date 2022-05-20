std::mutex mutex;
int fun() {
	mutex.lock();
	bool succeeded = doWork();
	if (!succeeded) {
		// BAD: this does not release the mutex
		return -1
	}
	mutex.unlock();
	return 1;
}
