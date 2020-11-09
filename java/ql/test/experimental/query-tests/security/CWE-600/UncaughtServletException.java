import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

class UncaughtServletException extends HttpServlet {
	// BAD - Tests `doGet` without catching exceptions.
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String ip = request.getParameter("srcIP");
		InetAddress addr = InetAddress.getByName(ip);  // getByName(String) throws UnknownHostException

		String userId = request.getRemoteUser();
		Integer.parseInt(userId);  // Integer.parse(String) throws RuntimeException
	}

	// GOOD - Tests `doPost` with catching exceptions.
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);

			String userId = request.getRemoteUser();
			Integer.parseInt(userId);  // Integer.parse(String) throws RuntimeException
		} catch (UnknownHostException uhex) {
			uhex.printStackTrace();
		} catch (RuntimeException re) {
			re.printStackTrace();	
		}
	}

	// GOOD - Tests `doPut` without user provided data and without catching exceptions.
	public void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String ip = "10.100.10.81";
		InetAddress addr = InetAddress.getByName(ip); // GOOD: hard-coded variable value or system property not controlled by attacker
	}

	// GOOD - Tests rethrowing caught exceptions without stack trace, which the typical programming practice.
	public void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			throw new IOException("Host not found "+uhex.getMessage());
		}
	}

	// BAD - Tests rethrowing caught exceptions with stack trace.
	public void doOptions(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			uhex.printStackTrace();
			throw uhex;
		}
	}

	// GOOD - Tests invoking another top-level method.
	public void doHead(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doGet(request, response);
	}

	// BAD - Tests nested try-blocks without catching runtime exceptions.
	public void service(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = null;
			try {
				addr = InetAddress.getByName(ip);

				String userId = request.getRemoteUser();
				Integer.parseInt(userId);  // Integer.parse(String) throws RuntimeException		
			} catch (UnknownHostException uhex) {
				throw new UnknownHostException("Got exception "+uhex.getMessage());
			}
		} catch (IOException ie) {
			ie.printStackTrace();
		}
	}

	// GOOD - Tests nested try-blocks with catching all exceptions.
	public void doTrace(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			try {
				String ip = request.getParameter("srcIP");
				InetAddress addr = null;
				try {
					addr = InetAddress.getByName(ip);

					String userId = request.getRemoteUser();
					Integer.parseInt(userId);  // Integer.parse(String) throws RuntimeException		
				} catch (UnknownHostException uhex) {
					throw new UnknownHostException("Got exception "+uhex.getMessage());
				}
			} catch (IOException ie) {
				ie.printStackTrace();
			}
		} catch (RuntimeException re) {
			re.printStackTrace();
		}
	}	
}
