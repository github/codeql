package test.cwe400.cwe.examples;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ThreadResourceAbuse extends HttpServlet {
	static final int DEFAULT_RETRY_AFTER = 5*1000;
	static final int MAX_RETRY_AFTER = 10*1000;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request parameter
		String delayTimeStr = request.getParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doGet2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request parameter
		try {
			int delayTime = request.getParameter("nodelay") != null ? 0 : Integer.valueOf(request.getParameter("DelayTime"));
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from init container parameter (not detected because LocalUserInput tends to add a lot of FP)
		String delayTimeStr = getServletContext().getInitParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request cookie
		Cookie[] cookies = request.getCookies();

		for ( int i=0; i<cookies.length; i++) {
			Cookie cookie = cookies[i];

			if (cookie.getName().equals("DelayTime")) {
				String delayTimeStr = cookie.getValue();
				try {
					int delayTime = Integer.valueOf(delayTimeStr);
					new CheckedSyncAction(delayTime).start();
				} catch (NumberFormatException e) {
				}
			}
		}
	}

	class UncheckedSyncAction extends Thread {
		int waitTime;

		public UncheckedSyncAction(int waitTime) {
			this.waitTime = waitTime;
		}

		@Override
		// BAD: no boundary check on wait time
		public void run() {
			try {
				Thread.sleep(waitTime);
				// Do other updates
			} catch (InterruptedException e) {
			}
		}
	}

	class CheckedSyncAction extends Thread {
		int waitTime;

		public CheckedSyncAction(int waitTime) {
			this.waitTime = waitTime;
		}

		// GOOD: enforce an upper limit on wait time
		@Override
		public void run() {
			try {
				if (waitTime > 0 && waitTime < 5000) {
					Thread.sleep(waitTime);
					// Do other updates
				}
			} catch (InterruptedException e) {
			}
		}
	}

	class CheckedSyncAction2 extends Thread {
		int waitTime;

		public CheckedSyncAction2(int waitTime) {
			this.waitTime = waitTime;
		}

		// GOOD: enforce an upper limit on wait time
		@Override
		public void run() {
			try {
				if (waitTime >= 5000) {
					// No action
				} else {
					Thread.sleep(waitTime);
				}
				// Do other updates
			} catch (InterruptedException e) {
			}
		}
	}

	protected void doPost2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from init container parameter
		String delayTimeStr = getServletContext().getInitParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new CheckedSyncAction2(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doHead(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request cookie
		Cookie[] cookies = request.getCookies();

		for ( int i=0; i<cookies.length; i++) {
			Cookie cookie = cookies[i];

			if (cookie.getName().equals("DelayTime")) {
				String delayTimeStr = cookie.getValue();
				try {
					int delayTime = Integer.valueOf(delayTimeStr);
					TimeUnit.MILLISECONDS.sleep(delayTime);
					// Do other updates
				} catch (NumberFormatException ne) {
				} catch (InterruptedException ie) {
				}
			}
		}
	}

	int parseRetryAfter(String value) {
		if (value == null || value.isEmpty()) {
			return DEFAULT_RETRY_AFTER;
		}

		try {
			int n = Integer.parseInt(value);
			if (n < 0) {
				return DEFAULT_RETRY_AFTER;
			}

			return Math.min(n, MAX_RETRY_AFTER);
		} catch (NumberFormatException e) {
			return DEFAULT_RETRY_AFTER;
		}
	}

	protected void doHead2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request header
		String header = request.getHeader("Retry-After");
		int retryAfter = Integer.parseInt(header);

		try {
			// BAD: wait for retry-after without input validation
			Thread.sleep(retryAfter);
		} catch (InterruptedException ignore) {
			// ignore
		}
	}

	protected void doHead3(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request header
		String header = request.getHeader("Retry-After");
		int retryAfter = parseRetryAfter(header);

		try {
			// GOOD: wait for retry-after with input validation
			Thread.sleep(retryAfter);
		} catch (InterruptedException ignore) {
			// ignore
		}
	}
}
