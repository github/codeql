---
category: minorAnalysis
---
* Now alerts about exposing `exception.getMessage()` in servlet responses are split out of `java/stack-trace-exposure` into its own alert `java/error-message-exposure` because this is a better fit. 