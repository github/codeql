package javax.servlet;

import java.io.IOException;

public interface Filter {
    default public void init(FilterConfig filterConfig) throws ServletException {}
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException;
    default public void destroy() {}
}
