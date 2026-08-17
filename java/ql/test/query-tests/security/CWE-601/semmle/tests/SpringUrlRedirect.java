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
        return "redirect:" + path;
    }

    protected String ordinaryView(String path) {
        return "view:" + path;
    }

    protected String discardedRedirect(String path) {
        return "redirect:" + path;
    }
}

class LabeledRedirectView extends RedirectView {
    LabeledRedirectView(String label, String url) {
        super(url);
    }

    void setUrl(Object label) {
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
        return redirect(next); // $ Alert
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

    @GetMapping("/safe-model-value")
    public ModelAndView redirectInModel(HttpServletRequest request) {
        String value = "redirect:" + request.getParameter("value");
        return new ModelAndView("home", "value", value);
    }

    @GetMapping("/safe-discarded")
    public String discardedRedirectValue(HttpServletRequest request) {
        discardedRedirect(request.getParameter("next"));
        return "home";
    }

    @GetMapping("/safe-redirect-view")
    public RedirectView constantRedirectView() {
        return new RedirectView("https://example.com/account");
    }

    @GetMapping("/safe-subclass-label")
    public RedirectView customRedirectView(HttpServletRequest request) {
        String label = request.getParameter("label");
        return new LabeledRedirectView(label, "/account");
    }

    @GetMapping("/safe-set-url-overload")
    public RedirectView customSetUrl(HttpServletRequest request) {
        LabeledRedirectView view = new LabeledRedirectView("label", "/account");
        Object label = request.getParameter("label");
        view.setUrl(label);
        return view;
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

class SharedRedirectHelper {
    protected String redirectShared(String path) {
        return "redirect:" + path;
    }
}

@Controller
class MvcViewUser extends SharedRedirectHelper {
    @GetMapping("/constant-view")
    public String view() {
        return redirectShared("/account");
    }
}

@Controller
class ResponseBodyUser extends SharedRedirectHelper {
    @ResponseBody
    @GetMapping("/body-user")
    public String body(HttpServletRequest request) {
        return redirectShared(request.getParameter("value"));
    }
}
