import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.security.Principal;
import java.time.ZoneId;
import java.util.Locale;
import java.util.TimeZone;
import javax.servlet.http.HttpSession;
import javax.servlet.http.PushBuilder;
import javax.servlet.ServletRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.bind.annotation.MatrixVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.SessionAttribute;

public class Test {

    static void sink(Object o) {}

    @Controller
    static class NotTaintedTest {
        @RequestMapping("/")
        public void get(WebRequest src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(NativeWebRequest src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(ServletRequest src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(HttpSession src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(PushBuilder src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(Principal src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(HttpMethod src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(Locale src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(TimeZone src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(ZoneId src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(OutputStream src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(Writer src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(RedirectAttributes src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(Errors src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(SessionStatus src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(UriComponentsBuilder src) {
            sink(src);
        }

        @RequestMapping("/")
        public void get(Pageable src) {
            sink(src);
        }
    }

    @Controller
    static class ExplicitlyTaintedTest {
        @RequestMapping("/")
        public void get(InputStream src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void get(Reader src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void matrixVariable(@MatrixVariable Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void requestParam(@RequestParam Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void requestHeader(@RequestHeader Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void cookieValue(@CookieValue Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void requestPart(@RequestPart Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void pathVariable(@PathVariable Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void requestBody(@RequestBody Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void get(HttpEntity src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void requestAttribute(@RequestAttribute Object src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void sessionAttribute(@SessionAttribute Object src) {
            sink(src); // $hasValueFlow
        }
    }

    @Controller
    static class ImplicitlyTaintedTest {
        static class Pojo {
        }

        @RequestMapping("/")
        public void get(String src) {
            sink(src); // $hasValueFlow
        }

        @RequestMapping("/")
        public void get1(Pojo src) {
            sink(src); // $hasValueFlow
        }
    }
}
