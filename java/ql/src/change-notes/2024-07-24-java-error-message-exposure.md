---
category: minorAnalysis
---
* The query `java/stack-trace-exposure` no longer alerts about exposing `exception.getMessage()` in servlet responses. 
* The query `java/error-message-exposure` were added to experimental alerting about exposing `exception.getMessage()` in servlet responses. 