void g() {
	MyTask *task = NULL;

	try
	{
		task = new MyTask;

		...

		delete task;
		task = NULL;

		...
	} catch (...) {
		delete task; // GOOD: harmless if task is NULL
	}
}
