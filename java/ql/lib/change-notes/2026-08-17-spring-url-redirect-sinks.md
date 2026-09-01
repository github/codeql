---
category: minorAnalysis
---
* The `java/unvalidated-url-redirection` query now detects untrusted URLs used in Spring MVC
  `RedirectView` objects and `redirect:` view names, including view names constructed in helper
  methods called by request handlers.
