class ExtendedLog extends Log
{
	// ...

	protected void finalize() {
		// BAD: This empty 'finalize' stops 'super.finalize' from being executed.
	}
}

class Log implements Closeable
{
	// ...

	public void close() {
		// ...
	}

	protected void finalize() {
		close();
	}
}