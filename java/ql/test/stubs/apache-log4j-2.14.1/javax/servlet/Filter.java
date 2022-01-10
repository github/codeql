// Generated automatically from javax.servlet.Filter for testing purposes

package javax.servlet;

import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public interface Filter
{
    void destroy();
    void doFilter(ServletRequest p0, ServletResponse p1, FilterChain p2);
    void init(FilterConfig p0);
}
