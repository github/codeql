---
category: minorAnalysis
---
* The `java/unvalidated-url-redirection` query now detects untrusted URLs used in returned Spring MVC
  `RedirectView` objects and leading `redirect:` view names, including helper-generated names passed
  to returned `ModelAndView` objects. View objects returned by response-body handlers are also covered.
