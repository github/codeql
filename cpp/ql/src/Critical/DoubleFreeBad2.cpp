void g() {
	MyTask *task = NULL;

	try
	{
		task = new MyTask;

		...

		delete task;

		...
	} catch (...) {
		delete task; // BAD: potential double-free
	}
}
