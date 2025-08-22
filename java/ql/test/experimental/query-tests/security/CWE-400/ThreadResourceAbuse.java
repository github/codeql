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
		// BAD: Get thread pause time from request parameter without validation
		String delayTimeStr = request.getParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doGet2(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BAD: Get thread pause time from request parameter without validation
		try {
			int delayTime = request.getParameter("nodelay") != null ? 0 : Integer.valueOf(request.getParameter("DelayTime"));
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BAD: Get thread pause time from context init parameter without validation
		String delayTimeStr = getServletContext().getInitParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// GOOD: Get thread pause time from request cookie with validation
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
		public void run() {
			// BAD: no boundary check on wait time
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

		@Override
		public void run() {
			// GOOD: enforce an upper limit on wait time
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

		@Override
		public void run() {
			// GOOD: enforce an upper limit on wait time
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
		// GOOD: Get thread pause time from init container parameter with validation
		String delayTimeStr = getServletContext().getInitParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new CheckedSyncAction2(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doHead(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BAD: Get thread pause time from request cookie without validation
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
		// BAD: Get thread pause time from request header without validation
		String header = request.getHeader("Retry-After");
		int retryAfter = Integer.parseInt(header);

		try {
			Thread.sleep(retryAfter);
		} catch (InterruptedException ignore) {
			// ignore
		}
	}

	protected void doHead3(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// GOOD: Get thread pause time from request header with validation
		String header = request.getHeader("Retry-After");
		int retryAfter = parseRetryAfter(header);

		try {
			Thread.sleep(retryAfter);
		} catch (InterruptedException ignore) {
			// ignore
		}
	}

	private long getContentLength(HttpServletRequest request) {
		long size = -1;
		try {
		  size = Long.parseLong(request.getHeader("Content-length"));
		} catch (NumberFormatException e) {
		}
		return size;
	}

	protected void doHead4(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BAD: Get thread pause time from request header without validation
		try {
			String uploadDelayStr = request.getParameter("delay");
			int uploadDelay = Integer.parseInt(uploadDelayStr);

			UploadListener listener = new UploadListener(uploadDelay, getContentLength(request));
		} catch (Exception e) { }
	}

	protected void doHead5(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BAD: Get thread pause time from request header with binary multiplication expression and without validation
		String header = request.getHeader("Retry-After");
		int retryAfter = Integer.parseInt(header);

		try {
			Thread.sleep(retryAfter * 1000);
		} catch (InterruptedException ignore) {
			// ignore
		}
	}

	protected void doHead6(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// BAD: Get thread pause time from request header with multiplication assignment operator and without validation
		String header = request.getHeader("Retry-After");
		int retryAfter = Integer.parseInt(header);

		retryAfter *= 1000;

		try {
			Thread.sleep(retryAfter);
		} catch (InterruptedException ignore) {
			// ignore
		}
	}
}
