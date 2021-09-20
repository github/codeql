package test.cwe400.cwe.examples;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ThreadResourceAbuse extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from request parameter
		String delayTimeStr = request.getParameter("DelayTime");
		try {
			int delayTime = Integer.valueOf(delayTimeStr);
			new UncheckedSyncAction(delayTime).start();
		} catch (NumberFormatException e) {
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get thread pause time from init container parameter
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
}
