import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

public class SensitiveGetQuery3 extends HttpServlet {
	// BAD - Tests sending sensitive information in a GET request.
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String username = getRequestParameter(request, "username");
		String password = getRequestParameter(request, "password");
		System.out.println("Username="+username+"; password="+password);
	}

	String getRequestParameter(HttpServletRequest request, String paramName) {
		return request.getParameter(paramName);
	}

	// GOOD - Tests sending sensitive information in a POST request.
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String username = getRequestParameter(request, "username");
		String password = getRequestParameter(request, "password");
		System.out.println("Username="+username+"; password="+password);
	}
}
