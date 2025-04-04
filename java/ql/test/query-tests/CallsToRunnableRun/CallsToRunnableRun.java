import java.lang.Runnable;

public class CallsToRunnableRun extends Thread implements Runnable{

	private Thread wrapped;
	private Runnable callback;

	@Override
	public void run() {
		wrapped.run();  // COMPLIANT: called within a `run` method
		callback.run(); // COMPLIANT: called within a `run` method
	}

	public void bad() {
		wrapped.run();  // $ Alert
		callback.run(); // COMPLIANT: called on a `Runnable` object
	}
}
