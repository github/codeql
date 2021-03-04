import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.util.StringUtils;

public class RefererFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        String refefer = request.getHeader("Referer");
        boolean result = verifReferer(refefer);
        if (result){
            filterChain.doFilter(servletRequest, servletResponse);
        }
        response.sendError(444, "Referer xxx.");
    }

    @Override
    public void destroy() {
    }

    public static boolean verifReferer(String referer){
        if (StringUtils.isEmpty(referer)){
            return false;
        }
        if (referer.startsWith("http://www.baidu.com/")){
            return true;
        }
        return false;
    }
}
