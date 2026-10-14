---
category: minorAnalysis
---
* Java taint-tracking queries now recognize equality and case-insensitive equality checks against fixed string constants as sanitizers. The queries `java/ssrf` and `java/unvalidated-url-redirection` also recognize checks of `URI.getHost()` against fixed collections of strings, including when the host is normalized to upper or lower case.
