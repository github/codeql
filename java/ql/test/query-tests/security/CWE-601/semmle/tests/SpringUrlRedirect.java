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

@Controller
class SpringRedirectRegressions extends BaseController {

    protected String embeddedRedirect(String path) {
        String base = "home";
        return base + "redirect:" + path;
    }

    protected String fixedRelativeRedirect(String tab) {
        return "redirect:/account?tab=" + tab;
    }

    protected String mixedRedirect(String path, boolean useConstant) {
        if (useConstant) {
            return "redirect:" + "/account";
        }
        return "home:" + path;
    }

    @GetMapping("/helper-model-and-view")
    public ModelAndView helperModelAndView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(redirect(next)); // $ Alert
    }

    @GetMapping("/helper-model-and-view-model")
    public ModelAndView helperModelAndViewWithModel(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(redirect(next), "note", "value"); // $ Alert
    }

    @GetMapping("/redirect-with-suffix")
    public String redirectWithSuffix(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return "redirect:" + next + "?tab=profile"; // $ Alert
    }

    @GetMapping("/local-model-and-view-name")
    public ModelAndView localModelAndViewName(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        String viewName = "redirect:" + next; // $ Alert
        return new ModelAndView(viewName);
    }

    @GetMapping("/safe-leading-view-name")
    public String leadingViewName(HttpServletRequest request) {
        String next = request.getParameter("next");
        String base = "home";
        return base + "redirect:" + next;
    }

    @GetMapping("/safe-leading-model-and-view")
    public ModelAndView leadingModelAndView(HttpServletRequest request) {
        String next = request.getParameter("next");
        String base = "home";
        return new ModelAndView(base + "redirect:" + next);
    }

    @GetMapping("/safe-leading-helper-model-and-view")
    public ModelAndView leadingHelperModelAndView(HttpServletRequest request) {
        return new ModelAndView("home" + redirect(request.getParameter("next")));
    }

    @GetMapping("/safe-embedded-helper-prefix")
    public String embeddedHelperPrefix(HttpServletRequest request) {
        return embeddedRedirect(request.getParameter("next"));
    }

    @GetMapping("/safe-helper-model-value")
    public ModelAndView helperInModel(HttpServletRequest request) {
        return new ModelAndView("home", "value", redirect(request.getParameter("next")));
    }

    @GetMapping("/safe-discarded-model-and-view")
    public ModelAndView discardedModelAndView(HttpServletRequest request) {
        new ModelAndView(redirect(request.getParameter("next")));
        return new ModelAndView("home");
    }

    @GetMapping("/safe-logged-helper")
    public String loggedHelper(HttpServletRequest request) {
        System.out.println(redirect(request.getParameter("next")));
        return "home";
    }

    @GetMapping("/safe-leading-builder")
    public String leadingBuilder(HttpServletRequest request) {
        StringBuilder builder = new StringBuilder("home");
        builder.append("redirect:");
        builder.append(request.getParameter("next"));
        return builder.toString();
    }

    @GetMapping("/safe-leading-format")
    public String leadingFormat(HttpServletRequest request) {
        return "home" + String.format("redirect:%s", request.getParameter("next"));
    }

    @GetMapping("/safe-fixed-relative-helper")
    public ModelAndView fixedRelativeHelper(HttpServletRequest request) {
        return new ModelAndView(fixedRelativeRedirect(request.getParameter("tab")));
    }

    @GetMapping("/safe-mixed-helper")
    public ModelAndView mixedHelper(HttpServletRequest request, boolean useConstant) {
        return new ModelAndView(mixedRedirect(request.getParameter("next"), useConstant));
    }

    @GetMapping("/safe-validated-helper")
    public ModelAndView validatedHelper(HttpServletRequest request) throws Exception {
        java.net.URI uri = new java.net.URI(request.getParameter("next"));
        if ("example.com".equals(uri.getHost())) {
            return new ModelAndView(redirect(uri.toString()));
        }
        return new ModelAndView("home");
    }

    @GetMapping("/safe-overwritten-constructor-url")
    public RedirectView overwrittenConstructorUrl(HttpServletRequest request) {
        RedirectView view = new RedirectView(request.getParameter("next"));
        view.setUrl("/safe");
        return view;
    }

    @GetMapping("/safe-overwritten-setter-url")
    public RedirectView overwrittenSetterUrl(HttpServletRequest request) {
        RedirectView view = new RedirectView();
        view.setUrl(request.getParameter("next"));
        view.setUrl("/safe");
        return view;
    }

    @GetMapping("/safe-overwritten-model-and-view-name")
    public ModelAndView overwrittenModelAndViewName(HttpServletRequest request) {
        ModelAndView view = new ModelAndView("redirect:" + request.getParameter("next"));
        view.setViewName("home");
        return view;
    }
}

@Controller
class ResponseBodyRedirectRegressions extends BaseController {

    @ResponseBody
    @GetMapping("/body-redirect-view")
    public RedirectView redirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new RedirectView(next); // $ Alert
    }

    @ResponseBody
    @GetMapping("/body-model-and-view")
    public ModelAndView modelAndView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView("redirect:" + next); // $ Alert
    }

    @ResponseBody
    @GetMapping("/body-helper-model-and-view")
    public ModelAndView helperModelAndView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(redirect(next)); // $ Alert
    }
}

@RestController
class JsonRedirectRegressions extends BaseController {

    @GetMapping("/json-redirect-view")
    public RedirectView redirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new RedirectView(next); // $ Alert
    }

    @GetMapping("/json-model-and-view")
    public ModelAndView modelAndView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView("redirect:" + next); // $ Alert
    }

    @GetMapping("/json-helper-model-and-view")
    public ModelAndView helperModelAndView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(redirect(next)); // $ Alert
    }

    @GetMapping("/json-configured-redirect-view")
    public RedirectView configuredRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView();
        view.setUrl(next); // $ Alert
        return view;
    }

    @GetMapping("/json-object-redirect-view")
    public Object objectRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new RedirectView(next); // $ Alert
    }
}

@Controller
class SpringViewPropertyRegressions extends SpringRedirectRegressions {
    @GetMapping("/conditional-url-overwrite")
    public RedirectView conditionalUrlOverwrite(HttpServletRequest request, boolean replace) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        if (replace) {
            view.setUrl("/safe");
        }
        return view;
    }

    @GetMapping("/other-view-url-overwrite")
    public RedirectView otherViewUrlOverwrite(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        RedirectView other = new RedirectView("/account");
        other.setUrl("/safe");
        return view;
    }

    @GetMapping("/safe-alias-url-overwrite")
    public RedirectView aliasUrlOverwrite(HttpServletRequest request) {
        RedirectView view = new RedirectView(request.getParameter("next"));
        RedirectView alias = view;
        alias.setUrl("/safe");
        return view;
    }

    @GetMapping("/conditional-alias-url-overwrite")
    public RedirectView conditionalAliasUrlOverwrite(HttpServletRequest request, boolean replace) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        RedirectView alias = replace ? view : new RedirectView("/account");
        alias.setUrl("/safe");
        return view;
    }

    @GetMapping("/returned-before-url-overwrite")
    public RedirectView returnedBeforeUrlOverwrite(HttpServletRequest request, boolean keepOriginal) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        if (keepOriginal) {
            return view;
        }
        view.setUrl("/safe");
        return view;
    }

    @GetMapping("/later-unsafe-url-overwrite")
    public RedirectView laterUnsafeUrlOverwrite(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        view.setUrl("/safe");
        view.setUrl(next); // $ Alert
        return view;
    }

    @GetMapping("/safe-mixed-helper-string")
    public String mixedHelperString(HttpServletRequest request, boolean useConstant) {
        return mixedRedirect(request.getParameter("next"), useConstant);
    }

    @ResponseBody
    @GetMapping("/safe-body-shared-view-helper")
    public String responseBodySharedViewHelper(HttpServletRequest request) {
        return redirect(request.getParameter("next"));
    }
}

@Controller
class SpringModelAndViewPropertyRegressions extends BaseController {
    @GetMapping("/later-unsafe-model-and-view-overwrite")
    public ModelAndView laterUnsafeModelAndViewOverwrite(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        ModelAndView view = new ModelAndView("redirect:" + next); // $ Alert
        view.setViewName("home");
        view.setViewName("redirect:" + next);
        return view;
    }
}

@Controller
class SpringAdditionalPrefixRegressions extends BaseController {
    protected String conditionalMixedRedirect(String path, boolean useConstant) {
        return useConstant ? redirect("/safe") : "home:" + path;
    }

    protected String branchingRedirect(String path, boolean useConstant) {
        if (useConstant) {
            return "redirect:" + "/account";
        }
        return "redirect:" + path;
    }

    private static void restoreUrl(RedirectView view, String url) {
        view.setUrl(url);
    }

    @GetMapping("/safe-conditional-mixed-helper")
    public ModelAndView conditionalMixedHelper(HttpServletRequest request, boolean useConstant) {
        return new ModelAndView(conditionalMixedRedirect(request.getParameter("next"), useConstant));
    }

    @GetMapping("/helper-restores-unsafe-url")
    public RedirectView helperRestoresUnsafeUrl(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        view.setUrl("/safe");
        restoreUrl(view, next);
        return view;
    }

    @GetMapping("/safe-outer-relative-prefix")
    public String outerRelativePrefix(HttpServletRequest request) {
        String next = request.getParameter("next");
        return "redirect:/safe/" + ("redirect:" + next);
    }

    @GetMapping("/safe-outer-relative-model-and-view")
    public ModelAndView outerRelativeModelAndView(HttpServletRequest request) {
        String next = request.getParameter("next");
        return new ModelAndView("redirect:/safe/" + ("redirect:" + next));
    }

    @GetMapping("/branching-view-name")
    public String branchingViewName(HttpServletRequest request, boolean useConstant) {
        String next = request.getParameter("next"); // $ Source
        return branchingRedirect(next, useConstant); // $ Alert
    }

    @GetMapping("/branching-model-and-view-name")
    public ModelAndView branchingModelAndViewName(HttpServletRequest request, boolean useConstant) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(branchingRedirect(next, useConstant)); // $ Alert
    }
}

@Controller
class SpringRedirectHelperRegressions extends BaseController {
    protected String internallyValidatedRedirect(String path) {
        if (!java.util.Arrays.asList("/account", "/home").contains(path)) {
            return "redirect:/safe";
        }
        return "redirect:" + path;
    }

    protected String internallySourcedRedirect(HttpServletRequest request) {
        String next = request.getHeader("referer"); // $ Source
        return "redirect:" + next;
    }

    protected String secondRedirect(String... paths) {
        return "redirect:" + paths[1];
    }

    protected String fixedBranchingRedirect(String tab, boolean useConstant) {
        if (useConstant) {
            return "redirect:/account";
        }
        return "redirect:/account?tab=" + tab;
    }

    private static void restoreArrayUrl(RedirectView[] views, String url) {
        views[0].setUrl(url);
    }

    @GetMapping("/safe-internally-validated-helper")
    public ModelAndView internallyValidatedHelper(HttpServletRequest request) {
        return new ModelAndView(internallyValidatedRedirect(request.getParameter("next")));
    }

    @GetMapping("/internally-sourced-helper")
    public ModelAndView internallySourcedHelper(HttpServletRequest request) {
        return new ModelAndView(internallySourcedRedirect(request)); // $ Alert
    }

    @GetMapping("/varargs-model-and-view-name")
    public ModelAndView varargsModelAndViewName(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(secondRedirect("/safe", next)); // $ Alert
    }

    @GetMapping("/safe-fixed-branching-helper")
    public ModelAndView fixedBranchingHelper(HttpServletRequest request, boolean useConstant) {
        return new ModelAndView(fixedBranchingRedirect(request.getParameter("tab"), useConstant));
    }

    @GetMapping("/ambiguous-finally-url-overwrite")
    public RedirectView ambiguousFinallyUrlOverwrite(
            HttpServletRequest request, boolean flag, RedirectView supplied) {
        String next = request.getParameter("next"); // $ Source
        RedirectView result = new RedirectView(next); // $ Alert
        RedirectView view = result;
        try {
            if (flag) {
                return result;
            }
            view = supplied;
        } finally {
            view.setUrl("/safe");
        }
        return result;
    }

    @GetMapping("/array-helper-restores-unsafe-url")
    public RedirectView arrayHelperRestoresUnsafeUrl(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        RedirectView view = new RedirectView(next); // $ Alert
        RedirectView[] views = { view };
        view.setUrl("/safe");
        restoreArrayUrl(views, next);
        return view;
    }
}

@Controller
class SpringRedirectFallbackRegressions extends BaseController {
    protected String branchingFallbackRedirect(String path, boolean useRedirect) {
        if (useRedirect) {
            return "redirect:" + path;
        }
        return "home";
    }

    @GetMapping("/branching-helper-with-ordinary-fallback")
    public ModelAndView branchingFallbackModelAndView(HttpServletRequest request, boolean useRedirect) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView(branchingFallbackRedirect(next, useRedirect)); // $ Alert
    }
}

@Controller
class SpringModelAttributeRedirectRegressions extends BaseController {
    @org.springframework.web.bind.annotation.ModelAttribute("value")
    @GetMapping("/safe-model-attribute-value")
    public String modelAttributeValue(HttpServletRequest request) {
        return "redirect:" + request.getParameter("next");
    }

    @org.springframework.web.bind.annotation.ModelAttribute("value")
    @GetMapping("/model-attribute-redirect-view")
    public RedirectView modelAttributeRedirectView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new RedirectView(next); // $ Alert
    }

    @org.springframework.web.bind.annotation.ModelAttribute("value")
    @GetMapping("/model-attribute-model-and-view")
    public ModelAndView modelAttributeModelAndView(HttpServletRequest request) {
        String next = request.getParameter("next"); // $ Source
        return new ModelAndView("redirect:" + next); // $ Alert
    }
}
