import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DotRegexFilter implements Filter {
	private static final String PROTECTED_PATTERN = "/protected/.*";
	private static final String CONSTRAINT_PATTERN = "/protected/xyz\\.xml";

	private ServletContext context;

	public void init(FilterConfig config) throws ServletException {
		this.context = config.getServletContext();
	}

	// BAD: A string with line return e.g. `/protected/%0dxyz` can bypass the path check
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String source = httpRequest.getPathInfo();

		Pattern p = Pattern.compile(PROTECTED_PATTERN);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!httpRequest.getSession().getAttribute("secAttr").equals("secValue")) {
				// Redirect to the login page
				httpResponse.sendRedirect("/login.html");
			} else {
				// Not protected page - pass the request along the filter chain
				chain.doFilter(request, response);
			}
		}
	}

	// GOOD: A string with line return e.g. `/protected/%0dxyz` cannot bypass the path check
	public void doFilter2(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		String source = httpRequest.getPathInfo();

		Pattern p = Pattern.compile(CONSTRAINT_PATTERN);
		Matcher m = p.matcher(source);

		if (m.matches()) {
			// Protected page - check access token and redirect to login page
			if (!httpRequest.getSession().getAttribute("secAttr").equals("secValue")) {
				// Redirect to the login page
				httpResponse.sendRedirect("/login.html");
			} else {
				// Not protected page - pass the request along the filter chain
				chain.doFilter(request, response);
			}
		}
	}

	public void destroy() {
		// Close resources
	}
}