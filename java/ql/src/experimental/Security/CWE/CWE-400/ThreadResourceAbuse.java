public class ThreadResourceAbuse extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request parameter
		String delayTimeStr = request.getParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new SyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	class SyncAction extends Thread {
		int waitTime;

		public SyncAction(int waitTime) {
			this.waitTime = waitTime;
		}

		@Override
		public void run() {
			try {
				{
					// BAD: no boundary check on wait time
					Thread.sleep(waitTime);
				}


				{
					// GOOD: enforce an upper limit on wait time
					if (waitTime > 0 && waitTime < 5000) {
						Thread.sleep(waitTime);
					}
				}

				//Do other updates
			} catch (InterruptedException e) {
			}
		}
	}
}
