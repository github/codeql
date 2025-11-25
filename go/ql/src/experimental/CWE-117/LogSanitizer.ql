/**
 * LogSanitizer.ql
 *
 * Filter/suppress log-injection findings when the taint flow can be shown to
 * pass through a sanitizer (including zap custom encoders).
 *
 * NOTE: This is a conservative template. Integrate with your existing
 * taint-tracking / source/sink predicates used by your log-injection rules.
 */

import go
import go.security.dataflow.TaintTracking as T
// adjust imports above if your repo uses a different taint package

// Reuse the library predicates
import LogSanitizer

/**
 * A wrapper sink used for demonstration. Replace with the actual log sink
 * definitions used by your log-injection query if you want precise suppression.
 */
class LogSink extends T.Sink {
  LogSink() { this = T.Sink("LogSink") }
}

/**
 * Find flows from sources to log sinks but ignore flows that pass through a sanitizer.
 * This query demonstrates the pattern — adapt to concrete source/sink definitions.
 */
from T.Source src, T.Sink sink, Function sanitizerFn
where
  src.flowsTo(sink) and
  not exists(sanitizerFn |
    isSanitizer(sanitizerFn) and
    // sanitizer function appears somewhere on the flow path
    src.flowsTo(sanitizerFn) and
    sanitizerFn.flowsTo(sink)
  )
select sink, "Possible unsanitized value logged (no sanitizer detected on flow)."