public class UnsafeServletRequestDispatch extends HttpServlet {
	private static final String BASE_PATH = "/pages";

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		{
			// GOOD: whitelisted URI
			if (action.equals("Login")) {
				ServletContext sc = cfg.getServletContext();
				RequestDispatcher rd = sc.getRequestDispatcher("/Login.jsp");
				rd.forward(request, response);
			} 
		}

		{
			// BAD: Request dispatcher constructed from `ServletContext` without input validation
			String returnURL = request.getParameter("returnURL");
			ServletConfig cfg = getServletConfig();

			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL);
			rd.forward(request, response);
		}

		{
			// BAD: Request dispatcher without path traversal check 
			String path = request.getParameter("path");

			// A sample payload "/pages/welcome.jsp/../WEB-INF/web.xml" can bypass the `startsWith` check 
			// The payload "/pages/welcome.jsp/../../%57EB-INF/web.xml" can bypass the check as well since RequestDispatcher will decode `%57` as `W`  
			if (path.startsWith(BASE_PATH)) {
				request.getServletContext().getRequestDispatcher(path).include(request, response);
			}
		}
	}

	{
		// GOOD: Request dispatcher with path traversal check 
		String path = request.getParameter("path");

		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getServletContext().getRequestDispatcher(path).include(request, response);
		}
	}

	{
		// GOOD: Request dispatcher with path normalization 
		String path = request.getParameter("path");
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		// /pages/welcome.jsp/../../WEB-INF/web.xml becomes /WEB-INF/web.xml
		// /pages/welcome.jsp/../../%57EB-INF/web.xml becomes /%57EB-INF/web.xml
		if (requestedPath.startsWith(BASE_PATH)) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response);
		}
	}

	{
		// BAD: Request dispatcher with improper negation check and without url decoding 
		String path = request.getParameter("path");
		Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();

		if (!requestedPath.startsWith("/WEB-INF") && !requestedPath.startsWith("/META-INF")) {
			request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response);
		}
	}

	{
		// GOOD: Request dispatcher with path traversal check and url decoding
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
