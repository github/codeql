public class UnsafeRequestDispatch extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		ServletConfig cfg = getServletConfig();
		if (action.equals("Login")) {
			ServletContext sc = cfg.getServletContext();
			
			// GOOD: Request dispatcher with a whitelisted URI
			RequestDispatcher rd = sc.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			ServletContext sc = cfg.getServletContext();

			// BAD: Request dispatcher constructed from `ServletContext` with user controlled input 
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL);
			rd.forward(request, response);
		}
	}
}
