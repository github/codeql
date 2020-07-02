import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

class UncaughtServletException extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String ip = request.getParameter("srcIP");
		InetAddress addr = InetAddress.getByName(ip); // BAD: getByName(String) throws UnknownHostException

		String userId = request.getRemoteUser();
		Integer.parseInt(userId); //BAD: Integer.parse(String) throws RuntimeException
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {
			String ip = request.getParameter("srcIP");
			InetAddress addr = InetAddress.getByName(ip);
		} catch (UnknownHostException uhex) {
			uhex.printStackTrace();
		}
	}

	public void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String ip = "10.100.10.81";
		InetAddress addr = InetAddress.getByName(ip); // GOOD: hard-coded variable value or system property not controlled by attacker
	}

}