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
    public RedirectView bad1(String redirectUrl, HttpServletResponse response) throws Exception { // $ Source
        RedirectView rv = new RedirectView();
        rv.setUrl(redirectUrl); // $ Alert
        return rv;
    }

    @GetMapping("url2")
    public String bad2(String redirectUrl) { // $ Source
        String url = "redirect:" + redirectUrl; // $ Alert
        return url;
    }

    @GetMapping("url3")
    public RedirectView bad3(String redirectUrl) { // $ Source
        RedirectView rv = new RedirectView(redirectUrl); // $ Alert
        return rv;
    }

    @GetMapping("url4")
    public ModelAndView bad4(String redirectUrl) { // $ Source
        return new ModelAndView("redirect:" + redirectUrl); // $ Alert
    }

    @GetMapping("url5")
    public String bad5(String redirectUrl) { // $ Source
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("redirect:");
        stringBuffer.append(redirectUrl); // $ Alert
        return stringBuffer.toString();
    }

    @GetMapping("url6")
    public String bad6(String redirectUrl) { // $ Source
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append("redirect:");
        stringBuilder.append(redirectUrl); // $ Alert
        return stringBuilder.toString();
    }

    @GetMapping("url7")
    public String bad7(String redirectUrl) { // $ Source
        return "redirect:" + String.format("%s/?aaa", redirectUrl); // $ Alert
    }

    @GetMapping("url8")
    public String bad8(String redirectUrl, String token) { // $ Source
        return "redirect:" + String.format(redirectUrl + "?token=%s", token); // $ Alert
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
    public ResponseEntity<Void> bad9(String redirectUrl) { // $ Source
        return ResponseEntity.status(HttpStatus.FOUND)
                .location(URI.create(redirectUrl)) // $ Alert
                .build();
    }

    @GetMapping("url13")
    public ResponseEntity<Void> bad10(String redirectUrl) { // $ Source
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setLocation(URI.create(redirectUrl));

        return new ResponseEntity<>(httpHeaders, HttpStatus.SEE_OTHER); // $ Alert
    }

    @GetMapping("url14")
    public ResponseEntity<Void> bad11(String redirectUrl) { // $ Source
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return ResponseEntity.status(HttpStatus.SEE_OTHER).headers(httpHeaders).build(); // $ Alert
    }

    @GetMapping("url15")
    public ResponseEntity<Void> bad12(String redirectUrl) { // $ Source
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return new ResponseEntity<>(httpHeaders, HttpStatus.SEE_OTHER); // $ Alert
    }

    @GetMapping("url16")
    public ResponseEntity bad13(String redirectUrl) { // $ Source
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return new ResponseEntity<>("TestBody", httpHeaders, HttpStatus.SEE_OTHER); // $ Alert
    }

    @GetMapping("url17")
    public ResponseEntity bad14(String redirectUrl) { // $ Source
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setLocation(URI.create(redirectUrl));

        return new ResponseEntity<>("TestBody", httpHeaders, HttpStatus.SEE_OTHER); // $ Alert
    }
}
