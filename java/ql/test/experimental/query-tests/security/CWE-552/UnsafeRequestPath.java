import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// @WebFilter("/*")
public class UnsafeRequestPath implements Filter {
	private static final String BASE_PATH = "/pages";

	@Override
	// BAD: Request dispatcher from servlet path without check 
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();
		// A sample payload "/%57EB-INF/web.xml" can bypass this `startsWith` check
		if (path != null && !path.startsWith("/WEB-INF")) {
			request.getRequestDispatcher(path).forward(request, response);
		} else {
			chain.doFilter(request, response);
		}
	}

	// GOOD: Request dispatcher from servlet path with check 
	public void doFilter2(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();
		
		if (path.startsWith(BASE_PATH) && !path.contains("..")) {
			request.getRequestDispatcher(path).forward(request, response);
		} else {
			chain.doFilter(request, response);
		}
	}

	// GOOD: Request dispatcher from servlet path with whitelisted string comparison 
	public void doFilter3(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {
		String path = ((HttpServletRequest) request).getServletPath();
		
		if (path.equals("/comaction")) {
			request.getRequestDispatcher(path).forward(request, response);
		} else {
			chain.doFilter(request, response);
		}
	}
}
