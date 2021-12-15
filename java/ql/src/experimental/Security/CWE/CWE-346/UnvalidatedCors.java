import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;

public class CorsFilter implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {}

    public void doFilter(ServletRequest req, ServletResponse res,
            FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String url = request.getHeader("Origin");

        if (!StringUtils.isEmpty(url)) {
            String val = response.getHeader("Access-Control-Allow-Origin");

            if (StringUtils.isEmpty(val)) {
                response.addHeader("Access-Control-Allow-Origin", url); // BAD -> User controlled CORS header being set here.
                response.addHeader("Access-Control-Allow-Credentials", "true");
            }
        }

        if (!StringUtils.isEmpty(url)) {
            List<String> checkorigins = Arrays.asList("www.example.com", "www.sub.example.com");

            if (checkorigins.contains(url)) { // GOOD -> Origin is validated here.
                response.addHeader("Access-Control-Allow-Origin", url);
                response.addHeader("Access-Control-Allow-Credentials", "true");
            }
        }

        chain.doFilter(req, res);
    }

    public void destroy() {}
}
