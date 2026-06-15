public class UrlForward extends HttpServlet {
	private static final String VALID_FORWARD = "https://cwe.mitre.org/data/definitions/552.html";

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ServletConfig cfg = getServletConfig();
		ServletContext sc = cfg.getServletContext();

		// BAD: a request parameter is incorporated without validation into a URL forward
		sc.getRequestDispatcher(request.getParameter("target")).forward(request, response);

		// GOOD: the request parameter is validated against a known fixed string
		if (VALID_FORWARD.equals(request.getParameter("target"))) {
			sc.getRequestDispatcher(VALID_FORWARD).forward(request, response);
		}
	}
}
