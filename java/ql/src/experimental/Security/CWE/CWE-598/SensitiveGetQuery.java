public class SensitiveGetQuery extends HttpServlet {
	// BAD - Tests sending sensitive information in a GET request.
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String password = request.getParameter("password");
		System.out.println("password = " + password);
	}
	
	// GOOD - Tests sending sensitive information in a POST request.
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String password = request.getParameter("password");
		System.out.println("password = " + password);
	}
}
