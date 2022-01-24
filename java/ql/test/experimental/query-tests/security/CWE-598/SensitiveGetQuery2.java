import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

public class SensitiveGetQuery2 extends HttpServlet {
	// BAD - Tests retrieving sensitive information through `request.getParameterMap()` in a GET request.
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Map map = request.getParameterMap();
		String username = (String) map.get("username");
		String password = (String) map.get("password");
		processUserInfo(username, password);
	}

	void processUserInfo(String username, String password) {
		System.out.println("username = " + username+"; password "+password);
	}

	// GOOD - Tests retrieving sensitive information through `request.getParameterMap()` in a POST request.
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Map map = request.getParameterMap();
		String username = (String) map.get("username");
		String password = (String) map.get("password");
		processUserInfo(username, password);
	}
}
