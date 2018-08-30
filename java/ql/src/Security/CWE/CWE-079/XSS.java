public class XSS extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: a request parameter is written directly to an error response page
		response.sendError(HttpServletResponse.SC_NOT_FOUND,
				"The page \"" + request.getParameter("page") + "\" was not found.");
	}
}
