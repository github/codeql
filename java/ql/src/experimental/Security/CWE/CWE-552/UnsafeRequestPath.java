public class UnsafeRequestPath implements Filter {
	private static final String BASE_PATH = "/pages";

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
		throws IOException, ServletException {

		{
			// BAD: Request dispatcher from servlet path without check 
			String path = ((HttpServletRequest) request).getServletPath();
			// A sample payload "/%57EB-INF/web.xml" can bypass this `startsWith` check
			if (path != null && !path.startsWith("/WEB-INF")) {
				request.getRequestDispatcher(path).forward(request, response);
			} else {
				chain.doFilter(request, response);
			}
		}

		{
			// GOOD: Request dispatcher from servlet path with path traversal check 
			String path = ((HttpServletRequest) request).getServletPath();
		
			if (path.startsWith(BASE_PATH) && !path.contains("..")) {
				request.getRequestDispatcher(path).forward(request, response);
			} else {
				chain.doFilter(request, response);
			}
		}
	}
}
