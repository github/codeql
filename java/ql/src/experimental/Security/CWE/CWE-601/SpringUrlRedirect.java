import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

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
    public ResponseEntity<Void> bad5(String redirectUrl) {
        return ResponseEntity.status(HttpStatus.FOUND)
                .location(URI.create(redirectUrl))
                .build();
    }

    @GetMapping("url6")
    public ResponseEntity<Void> bad6(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setLocation(URI.create(redirectUrl));

        return new ResponseEntity<>(httpHeaders, HttpStatus.SEE_OTHER);
    }

    @GetMapping("url7")
    public ResponseEntity<Void> bad7(String redirectUrl) {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Location", redirectUrl);

        return ResponseEntity.status(HttpStatus.SEE_OTHER).headers(httpHeaders).build();
    }

    @GetMapping("url8")
    public RedirectView good1(String redirectUrl) {
        RedirectView rv = new RedirectView();
        if (redirectUrl.startsWith(VALID_REDIRECT)){
            rv.setUrl(redirectUrl);
        }else {
            rv.setUrl(VALID_REDIRECT);
        }
        return rv;
    }
}
