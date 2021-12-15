import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ClientSuppliedIpUsedInSecurityCheck {

    @Autowired
    private HttpServletRequest request;

    @GetMapping(value = "bad1")
    public void bad1(HttpServletRequest request) {
        String ip = getClientIP();
        if (!StringUtils.startsWith(ip, "192.168.")) {
            new Exception("ip illegal");
        }
    }

    @GetMapping(value = "bad2")
    public void bad2(HttpServletRequest request) {
        String ip = getClientIP();
        if (!"127.0.0.1".equals(ip)) {
            new Exception("ip illegal");
        }
    }

    @GetMapping(value = "good1")
    @ResponseBody
    public String good1(HttpServletRequest request) {
        String ip = request.getHeader("X-FORWARDED-FOR");
        // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
        ip = ip.split(",")[ip.split(",").length - 1];
        if (!StringUtils.startsWith(ip, "192.168.")) {
            new Exception("ip illegal");
        }
        return ip;
    }

    protected String getClientIP() {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }
}
