class RAII_Mutex
{
	std::mutex lock;
public:
	RAII_Mutex(mutex m) : lock(m)
	{
		lock.lock();
	}

	~RAII_Mutex()
	{
		lock.unlock();
	}
};


std::mutex mutex;
int fun() {
	RAII_Mutex(mutex);

	bool succeeded = doWork();
	if (!succeeded) {
		// GOOD: the RAII_Mutex is destroyed, releasing the lock
		return -1
	}
	
	return 1;
}