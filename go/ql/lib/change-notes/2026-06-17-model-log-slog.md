---
category: minorAnalysis
---
* Added models for the `log/slog` package (Go 1.21+). Its logging functions and
  `*slog.Logger` methods (`Debug`/`Info`/`Warn`/`Error`, their `Context`
  variants, and `Log`/`LogAttrs`) are now recognized as logging sinks, so the
  `go/log-injection` and `go/clear-text-logging` queries cover code that logs
  through `slog`.
