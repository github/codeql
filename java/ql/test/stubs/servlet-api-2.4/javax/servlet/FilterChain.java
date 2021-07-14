package javax.servlet;

import java.io.IOException;

public interface FilterChain {
   public void doFilter(ServletRequest request, ServletResponse response) throws IOException, ServletException;
}
