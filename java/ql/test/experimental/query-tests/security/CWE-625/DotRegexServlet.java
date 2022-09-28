import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;

public class DotRegexServlet extends HttpServlet {
	private static final String PROTECTED_PATTERN = "/protected/.*";
	private static final String CONSTRAINT_PATTERN = "/protected/xyz\\.xml";

	@Override
	// BAD: A string with line return e.g. `/protected/%0dxyz` can bypass the path check
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getPathInfo();

		Pattern p = Pattern.compile(PROTECTED_PATTERN);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				response.sendRedirect("/login.html");
				return;
			} else {
				// Not protected page - render content
			}
		}
	}

	// GOOD: A string with line return e.g. `/protected/%0dxyz` cannot bypass the path check
	protected void doGet2(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getPathInfo();

		Pattern p = Pattern.compile(PROTECTED_PATTERN, Pattern.DOTALL);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				response.sendRedirect("/login.html");
				return;
			} else {
				// Not protected page - render content
			}
		}
	}

	// BAD: A string with line return e.g. `/protected/%0axyz` can bypass the path check
	protected void doGet3(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getRequestURI();

		boolean matches = source.matches(PROTECTED_PATTERN);

		if (matches) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				response.sendRedirect("/login.html");
				return;
			} else {
				// Not protected page - render content
			}
		}
	}

	// BAD: A string with line return e.g. `/protected/%0axyz` can bypass the path check
	protected void doGet4(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getPathInfo();

		boolean matches = Pattern.matches(PROTECTED_PATTERN, source);

		if (matches) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				response.sendRedirect("/login.html");
				return;
			} else {
				// Not protected page - render content
			}
		}
	}

	// GOOD: Only a specific path can pass the validation
	protected void doGet5(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getPathInfo();

		Pattern p = Pattern.compile(CONSTRAINT_PATTERN);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				response.sendRedirect("/login.html");
				return;
			} else {
				// Not protected page - render content
			}
		}
	}

	// BAD: A string with line return e.g. `/protected/%0dxyz` can bypass the path check
	protected void doGet6(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getPathInfo();

		Pattern p = Pattern.compile(PROTECTED_PATTERN);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/login");
				dispatcher.forward(request, response);
			} else {
				// Not protected page - render content
				RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(source);
				dispatcher.forward(request, response);
			}
		}
	}

	// GOOD: A string with line return e.g. `/protected/%0dxyz` cannot bypass the path check
	protected void doGet7(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String source = request.getPathInfo();

		Pattern p = Pattern.compile(PROTECTED_PATTERN, Pattern.DOTALL);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!request.getSession().getAttribute("secAttr").equals("secValue")) {
				RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/login");
				dispatcher.forward(request, response);
			} else {
				// Not protected page - render content
				RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(source);
				dispatcher.include(request, response);
			}
		}
	}
}
