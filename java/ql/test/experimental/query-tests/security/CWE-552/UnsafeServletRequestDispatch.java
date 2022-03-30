import java.io.IOException;
import java.net.URLDecoder;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;

public class UnsafeServletRequestDispatch extends HttpServlet {
	private static final String BASE_PATH = "/pages";

	@Override
	// BAD: Request dispatcher constructed from `ServletContext` without input validation
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		ServletConfig cfg = getServletConfig();
		if (action.equals("Login")) {
			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL);
			rd.forward(request, response);
		}
	}

	@Override
	// BAD: Request dispatcher constructed from `HttpServletRequest` without input validation 
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		if (action.equals("Login")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			RequestDispatcher rd = request.getRequestDispatcher(returnURL);
			rd.forward(request, response);
		}
	}

	@Override
	// GOOD: Request dispatcher with a whitelisted URI
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action.equals("Login")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else if (action.equals("Register")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Register.jsp");
			rd.forward(request, response);
		}
	}

	// BAD: Request dispatcher without path traversal check 
	protected void doHead2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");

		// A sample payload "/pages/welcome.jsp/../WEB-INF/web.xml" can bypass the `startsWith` check 
		// The payload "/pages/welcome.jsp/../../%57EB-INF/web.xml" can bypass the check as well since RequestDispatcher will decode `%57` as `W`  
		if (path.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	// GOOD: Request dispatcher with path traversal check 
	protected void doHead3(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");		

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	// GOOD: Request dispatcher with path normalization and comparison
	protected void doHead4(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		// /pages/welcome.jsp/../../WEB-INF/web.xml becomes /WEB-INF/web.xml
		// /pages/welcome.jsp/../../%57EB-INF/web.xml becomes /%57EB-INF/web.xml
		if (requestedPath.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response);
		}
	}

	// BAD: Request dispatcher with negation check and path normalization, but without URL decoding
	protected void doHead5(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		if (!requestedPath.startsWith("/WEB-INF") && !requestedPath.startsWith("/META-INF")) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response);
		}
	}

	// GOOD: Request dispatcher with path traversal check and URL decoding
	protected void doHead6(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String path = request.getParameter("path");
		boolean hasEncoding = path.contains("%");
		while (hasEncoding) {
			path = URLDecoder.decode(path, "UTF-8");
			hasEncoding = path.contains("%");
		}

		if (!path.startsWith("/WEB-INF/") && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}
}
