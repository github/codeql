import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

class UncaughtServletException2 extends HttpServlet {
	// BAD - Tests rethrowing caught exceptions with stack trace using `initCause(...)`
	// Note this special case is not being handled by the query since in 99% of cases we're looking for `catch(Exception e) { ... throw e; }`
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			IOException ioException = new IOException();
			ioException.initCause(uhex);
			throw ioException;
		}
	}

	// BAD - Tests rethrowing caught exceptions with stack trace using the same exception variable.
	// Note this special case is not being handled by the query since in 99% of cases we're looking for `catch(Exception e) { ... throw e; }`
	public void doHead(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			throw new IOException(uhex);
		}
	}

	// BAD - Tests rethrowing caught exceptions with stack trace  using `addSuppressed(...)`.
	// Note this special case is not being handled by the query since in 99% of cases we're looking for `catch(Exception e) { ... throw e; }`
	public void doTrace(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			IOException ioException = new IOException();
			ioException.addSuppressed(uhex);
			throw ioException;
		}
	}

	// BAD - Tests rethrowing caught exceptions with stack trace using `initCause(...)`
	// Note this special case is not being handled by the query since in 99% of cases we're looking for `catch(Exception e) { ... throw e; }`
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			IOException ioException = new IOException();
			throw new IOException(ioException.initCause(uhex));
		}
	}
}
