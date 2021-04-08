import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UseOfLessTrustedSource {

    private static final Logger log = LoggerFactory.getLogger(UseOfLessTrustedSource.class);

    @GetMapping(value = "bad1")
    @ResponseBody
    public String bad1(HttpServletRequest request) {
        String remoteAddr = "";
        if (request != null) {
            remoteAddr = request.getHeader("X-FORWARDED-FOR");
            remoteAddr = remoteAddr.split(",")[0];
            if (remoteAddr == null || "".equals(remoteAddr)) {
                remoteAddr = request.getRemoteAddr();
            }
        }
        return remoteAddr;
    }

    @GetMapping(value = "bad2")
    public void bad2(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        
        log.debug("getClientIP header X-Forwarded-For:{}", ip);

        if (StringUtils.isBlank(ip) || StringUtils.equalsIgnoreCase("unknown", ip)) {
            ip = request.getHeader("Proxy-Client-IP");
            log.debug("getClientIP header Proxy-Client-IP:{}", ip);
        }
        if (StringUtils.isBlank(ip) || StringUtils.equalsIgnoreCase("unknown", ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
            log.debug("getClientIP header WL-Proxy-Client-IP:{}", ip);
        }
        if (StringUtils.isBlank(ip) || StringUtils.equalsIgnoreCase("unknown", ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
            log.debug("getClientIP header HTTP_CLIENT_IP:{}", ip);
        }
        if (StringUtils.isBlank(ip) || StringUtils.equalsIgnoreCase("unknown", ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
            log.debug("getClientIP header HTTP_X_FORWARDED_FOR:{}", ip);
        }
        if (StringUtils.isBlank(ip) || StringUtils.equalsIgnoreCase("unknown", ip)) {
            ip = request.getHeader("X-Real-IP");
            log.debug("getClientIP header X-Real-IP:{}", ip);
        }
        if (StringUtils.isBlank(ip) || StringUtils.equalsIgnoreCase("unknown", ip)) {
            ip = request.getRemoteAddr();
            log.debug("getRemoteAddr IP:{}", ip);
        }
        System.out.println("client ip is: " + ip);
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
}