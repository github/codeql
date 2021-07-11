import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;

public class UnsafeRequestDispatch extends HttpServlet {

	@Override
	// BAD: Request dispatcher constructed from `ServletContext` with user controlled input 
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		ServletConfig cfg = getServletConfig();
		if (action.equals("Login")) {
			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			ServletContext sc = cfg.getServletContext();
			RequestDispatcher rd = sc.getRequestDispatcher(returnURL);
			rd.forward(request, response);
		}
	}

	@Override
	// BAD: Request dispatcher constructed from `HttpServletRequest` with user controlled input 
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String returnURL = request.getParameter("returnURL");

		if (action.equals("Login")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else {
			RequestDispatcher rd = request.getRequestDispatcher(returnURL);
			rd.forward(request, response);
		}
	}

	@Override
	// GOOD: Request dispatcher with a whitelisted URI
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action.equals("Login")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Login.jsp");
			rd.forward(request, response);
		} else if (action.equals("Register")) {
			RequestDispatcher rd = request.getRequestDispatcher("/Register.jsp");
			rd.forward(request, response);
		}
	}

	@Override
	// BAD: Request dispatcher constructed from `HttpServletRequest` with user controlled input 
	protected void doHead(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String includeURL = request.getParameter("includeURL");
		request.getRequestDispatcher(includeURL).include(request, response);
	}
}
