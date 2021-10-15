public class ResponseSplitting extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// BAD: setting a cookie with an unvalidated parameter
		Cookie cookie = new Cookie("name", request.getParameter("name"));
		response.addCookie(cookie);

		// GOOD: remove special characters before putting them in the header
		String name = removeSpecial(request.getParameter("name"));
		Cookie cookie2 = new Cookie("name", name);
		response.addCookie(cookie2);
	}

	private static String removeSpecial(String str) {
		return str.replaceAll("[^a-zA-Z ]", "");
	}
}
