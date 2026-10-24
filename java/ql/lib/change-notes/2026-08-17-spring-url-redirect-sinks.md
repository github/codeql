---
category: minorAnalysis
---
* The `java/unvalidated-url-redirection` query now detects untrusted URLs used in returned Spring MVC
  `RedirectView` objects and leading `redirect:` view names, including helper-generated names passed
  to returned `ModelAndView` objects, conditional or branch-assigned names, and local prefix variables.
  Redirect views wrapped in `ModelAndView` and view objects returned by response-body handlers are
  also covered.
