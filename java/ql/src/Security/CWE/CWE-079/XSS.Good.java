public class XSS extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		String unsafeInput = request.getParameter("page");
        String safeInput = StringEscapeUtils.escapeHtml4(unsafeInput);
        // GOOD: the untrusted request parameter is html encoded for special characters before being written into the response string.
		response.getWriter().print(
				"The page \"" + safeInput + "\" was not found.");

	}
}