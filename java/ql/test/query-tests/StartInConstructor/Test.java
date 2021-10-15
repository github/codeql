import java.lang.Thread;

public class Test {
	Thread myThread;
	
	public Test() {
		myThread = new Thread("myThread");
		// BAD
		myThread.start();
	}
	
	public static final class Final {
		Thread myThread;

		public Final() {
			myThread = new Thread("myThread");
			// OK - class cannot be extended
			myThread.start();
		}
		
	}

	private static class Private {
		Thread myThread;

		public Private() {
			myThread = new Thread("myThread");
			// OK - class can only be extended in this file, and is not in fact extended
			myThread.start();
		}
		
	}
}