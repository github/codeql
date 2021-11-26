import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import java.net.URI;

@Controller
public class SpringUrlRedirect {

    private final static String VALID_REDIRECT = "http://127.0.0.1";

    @GetMapping("url1")
    public RedirectView bad1(String redirectUrl, HttpServletResponse response) throws Exception {
        RedirectView rv = new RedirectView();
        rv.setUrl(redirectUrl);
        return rv;
    }

    @GetMapping("url2")
    public String bad2(String redirectUrl) {
        String url = "redirect:" + redirectUrl;
        return url;
    }

    @GetMapping("url3")
    public RedirectView bad3(String redirectUrl) {
        RedirectView rv = new RedirectView(redirectUrl);
        return rv;
    }

    @GetMapping("url4")
    public ModelAndView bad4(String redirectUrl) {
        return new ModelAndView("redirect:" + redirectUrl);
    }

    @GetMapping("url5")
    public String bad5(String redirectUrl) {
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("redirect:");
        stringBuffer.append(redirectUrl);
        return stringBuffer.toString();
    }

    @GetMapping("url6")
    public String bad6(String redirectUrl) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("redirect:");
        stringBuilder.append(redirectUrl);
        return stringBuilder.toString();
    }

    @GetMapping("url7")
    public String bad7(String redirectUrl) {
        return "redirect:" + String.format("%s/?aaa", redirectUrl);
    }

    @GetMapping("url8")
    public String bad8(String redirectUrl, String token) {
        return "redirect:" + String.format(redirectUrl + "?token=%s", token);
    }

    @GetMapping("url9")
    public RedirectView good1(String redirectUrl) {
        RedirectView rv = new RedirectView();
        if (redirectUrl.startsWith(VALID_REDIRECT)){
            rv.setUrl(redirectUrl);
        }else {
            rv.setUrl(VALID_REDIRECT);
        }
        return rv;
    }

    @GetMapping("url10")
    public ModelAndView good2(String token) {
        String url = "/edit?token=" + token;
        return new ModelAndView("redirect:" + url);
    }

    @GetMapping("url11")
    public String good3(String status) {
        return "redirect:" + String.format("/stories/search/criteria?status=%s", status);
    }

    @GetMapping("url12")
    public ResponseEntity<Void> bad9(String redirectUrl) {
        return ResponseEntity.status(HttpStatus.FOUND)
                .location(URI.create(redirectUrl))
                .build();
    }

    @GetMapping("url13")
    public ResponseEntity<Void> bad10(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setLocation(URI.create(redirectUrl));

        return new ResponseEntity<>(httpHeaders, HttpStatus.SEE_OTHER);
    }

    @GetMapping("url14")
    public ResponseEntity<Void> bad11(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return ResponseEntity.status(HttpStatus.SEE_OTHER).headers(httpHeaders).build();
    }

    @GetMapping("url15")
    public ResponseEntity<Void> bad12(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return new ResponseEntity<>(httpHeaders, HttpStatus.SEE_OTHER);
    }

    @GetMapping("url16")
    public ResponseEntity bad13(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return new ResponseEntity<>("TestBody", httpHeaders, HttpStatus.SEE_OTHER);
    }

    @GetMapping("url17")
    public ResponseEntity bad14(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setLocation(URI.create(redirectUrl));

        return new ResponseEntity<>("TestBody", httpHeaders, HttpStatus.SEE_OTHER);
    }
}
