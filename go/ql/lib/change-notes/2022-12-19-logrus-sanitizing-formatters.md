---
category: minorAnalysis
---
* Modified the behaviour of the `go/log-injection` query for `logrus` so that logging functions are not marked as data flow sources if only sanitizing formatters are installed with `SetFormatter` and through the `Formatter` property of `Logger` objects.
