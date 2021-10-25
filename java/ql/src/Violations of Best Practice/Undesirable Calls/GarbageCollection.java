class RequestHandler extends Thread {
	private boolean isRunning;
	private Connection conn = new Connection();
	
	public void run() {
		while (isRunning) {
			Request req = conn.getRequest();
			// Process the request ...
			
			System.gc();  // This call may cause a garbage collection after each request.
						  // This will likely reduce the throughput of the RequestHandler
						  // because the JVM spends time on unnecessary garbage collection passes.
		}
	}
}