import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UseOfLessTrustedSource {

    @Autowired
    private HttpServletRequest request;

    @GetMapping(value = "bad1")
    public void bad1(HttpServletRequest request) {
        String ip = getClientIP();
        if (!StringUtils.startsWith(ip, "192.168.")) {
            new Exception("ip illegal");
        }
    }

    @GetMapping(value = "good1")
    @ResponseBody
    public String good1(HttpServletRequest request) {
        String remoteAddr = "";
        if (request != null) {
            remoteAddr = request.getHeader("X-FORWARDED-FOR");
            remoteAddr = remoteAddr.split(",")[remoteAddr.split(",").length - 1]; // good
            if (remoteAddr == null || "".equals(remoteAddr)) {
                remoteAddr = request.getRemoteAddr();
            }
        }
        return remoteAddr;
    }

    protected String getClientIP() {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }
}