public class SQLInjection extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

		StringBuilder sqlQueryBuilder = new StringBuilder();
		sqlQueryBuilder.append("SELECT * FROM user WHERE user_id='");
		sqlQueryBuilder.append(request.getParameter("user_id"));
		sqlQueryBuilder.append("'");

		// ...
	}
}
