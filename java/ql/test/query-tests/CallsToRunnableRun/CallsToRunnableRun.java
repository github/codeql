import java.lang.Runnable;

public class CallsToRunnableRun extends Thread implements Runnable{
	
	private Thread wrapped;
	private Runnable callback;
	
	@Override
	public void run() {
		wrapped.run();
		callback.run();
	}
	
	public void bad() {
		wrapped.run();
		callback.run();
	}
}
