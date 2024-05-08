void g() {
	MyTask *task = nullptr;

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
