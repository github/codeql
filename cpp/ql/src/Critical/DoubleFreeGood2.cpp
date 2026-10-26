void g() {
	MyTask *task = nullptr;

	try
	{
		task = new MyTask;

		...

		delete task;
		task = nullptr;

		...
	} catch (...) {
		delete task; // GOOD: harmless if task is NULL
	}
}
