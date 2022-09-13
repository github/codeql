public class XSS extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: a request parameter is written directly to the Servlet response stream
		response.getWriter().print(
				"The page \"" + request.getParameter("page") + "\" was not found.");

	}
}
