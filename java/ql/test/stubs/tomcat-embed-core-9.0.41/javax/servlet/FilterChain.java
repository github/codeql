package javax.servlet;

import java.io.IOException;

public interface FilterChain {
    void doFilter(ServletRequest var1, ServletResponse var2) throws IOException, ServletException;
}

