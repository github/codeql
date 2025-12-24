// Generated automatically from jakarta.servlet.Filter for testing purposes

package jakarta.servlet;

import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

public interface Filter
{
    default void destroy(){}
    default void init(FilterConfig p0){}
    void doFilter(ServletRequest p0, ServletResponse p1, FilterChain p2);
}
