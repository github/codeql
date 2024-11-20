---
category: minorAnalysis
---
* A call to a method whose name starts with "Debug", "Error", "Fatal", "Info", "Log", "Output", "Panic", "Print", "Trace", "Warn" or "With" defined on an interface whose name ends in "logger" or "Logger" is now considered a LoggerCall. In particular, it is a sink for `go/clear-text-logging` and `go/log-injection`. This may lead to some more alerts in those queries.
