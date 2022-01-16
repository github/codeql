public class UnsafeServletRequestDispatch extends HttpServlet {
	private static final String BASE_PATH = "/pages";

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		{
			ServletConfig cfg = getServletConfig();
			ServletContext sc = cfg.getServletContext();

			// GOOD: check for an explicitly permitted URI
			String action = request.getParameter("action");
			if (action.equals("Login")) {
				RequestDispatcher rd = sc.getRequestDispatcher("/Login.jsp");
				rd.forward(request, response);
			}

			// BAD: no URI validation
			String returnURL = request.getParameter("returnURL");
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL);
			rd.forward(request, response);

			// A sample payload "/pages/welcome.jsp/../WEB-INF/web.xml" can bypass the `startsWith` check
			// The payload "/pages/welcome.jsp/../../%57EB-INF/web.xml" can bypass the check as well since RequestDispatcher will decode `%57` as `W`
			String path = request.getParameter("path");

			// BAD: no check for path traversal
			if (path.startsWith(BASE_PATH)) {
				request.getServletContext().getRequestDispatcher(path).include(request, response);
			}

			// GOOD: To check there won't be unexpected path traversal, we can check for any `..` sequences and whether the URI starts with a given web root path.
			if (path.startsWith(BASE_PATH) && !path.contains("..")) {
				request.getServletContext().getRequestDispatcher(path).include(request, response);
			}

			// GOOD: Or alternatively we can use Path.normalize and check whether the URI starts with a given web root path.
			Path requestedPath = Paths.get(BASE_PATH).resolve(path).normalize();
			if (requestedPath.startsWith(BASE_PATH)) {
				request.getServletContext().getRequestDispatcher(requestedPath.toString()).forward(request, response);
			}

			// GOOD: Or alternatively ensure URL encoding is removed and then check for any `..` sequences.
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
}
