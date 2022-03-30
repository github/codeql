import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

public class SensitiveGetQuery4 extends HttpServlet {
	// BAD - Tests retrieving non-sensitive tokens and sensitive tokens in a GET request.
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String username = getRequestParameter(request, "username");
		String token = getRequestParameter(request, "token");
		String tokenType = getRequestParameter(request, "tokenType");
		String accessToken = getRequestParameter(request, "accessToken");
		System.out.println("Username="+username+"; token="+token+"; tokenType="+tokenType);
		System.out.println("AccessToken="+accessToken);
	}

	String getRequestParameter(HttpServletRequest request, String paramName) {
		return request.getParameter(paramName);
	}

	// GOOD - Tests retrieving non-sensitive tokens and sensitive tokens in a POST request.
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String username = getRequestParameter(request, "username");
		String token = getRequestParameter(request, "token");
		String tokenType = getRequestParameter(request, "tokenType");
		String accessToken = getRequestParameter(request, "accessToken");
		System.out.println("Username="+username+"; token="+token+"; tokenType="+tokenType);
		System.out.println("AccessToken="+accessToken);
	}
}
