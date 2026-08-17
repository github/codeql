package test.cwe601.cwe.examples;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

class BaseController {
    protected String redirect(String path) {
        return "redirect:" + path; // $ Alert
    }

    protected String ordinaryView(String path) {
        return "view:" + path;
    }

    protected String discardedRedirect(String path) {
        return "redirect:" + path;
    }
}

class CustomRedirectView extends RedirectView {
    CustomRedirectView(String url) {
        super(url);
    }
}

@Controller
public class SpringUrlRedirect extends BaseController {
    @GetMapping("/case1")
    public String directViewName(HttpServletRequest request) {
        String next = request.getHeader("referer"); // $ Source
        return "redirect:" + next; // $ Alert
    }

    @GetMapping("/case2")
    public ModelAndView modelAndView(HttpServletRequest request) {
        String next = request.getHeader("referer"); // $ Source
        return new ModelAndView("redirect:" + next); // $ Alert
    }

    @GetMapping("/case3")
    public RedirectView redirectView(HttpServletRequest request) {
        String next = request.getHeader("referer"); // $ Source
        return new RedirectView(next); // $ Alert
    }

    @GetMapping("/case4")
    public String helperViewName(HttpServletRequest request) {
        String next = request.getHeader("referer"); // $ Source
        return redirect(next);
    }

    @GetMapping("/case5")
    public RedirectView configuredRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView();
        view.setUrl(next); // $ Alert
        return view;
    }

    @GetMapping("/case6")
    public RedirectView overloadedRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new RedirectView(next, true); // $ Alert
    }

    @GetMapping("/case7")
    public RedirectView customRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new CustomRedirectView(next); // $ Alert
    }

    @GetMapping("/safe-constant")
    public String constantViewName() {
        return "redirect:/account";
    }

    @GetMapping("/safe-path")
    public String fixedPath(HttpServletRequest request) {
        String tab = request.getParameter("tab");
        return "redirect:/account?tab=" + tab;
    }

    @GetMapping("/safe-model-and-view")
    public ModelAndView ordinaryModelAndView(HttpServletRequest request) {
        String view = request.getParameter("view");
        return new ModelAndView(ordinaryView(view));
    }

    @GetMapping("/safe-discarded")
    public String discardedRedirectValue(HttpServletRequest request) {
        discardedRedirect(request.getParameter("next"));
        return "home";
    }

    @GetMapping("/safe-validated")
    public RedirectView validatedRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next");
        if ("https://example.com/account".equals(next)) {
            return new RedirectView("https://example.com/account");
        }
        return new RedirectView("https://example.com/account");
    }
}

@Controller
class ResponseBodyController {
    @ResponseBody
    @GetMapping("/body")
    public String responseBody(HttpServletRequest request) {
        return "redirect:" + request.getParameter("value");
    }
}

@RestController
class JsonController {
    @GetMapping("/json")
    public String responseBody(HttpServletRequest request) {
        return "redirect:" + request.getParameter("value");
    }
}
