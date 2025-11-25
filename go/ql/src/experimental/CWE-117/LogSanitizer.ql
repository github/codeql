/**
 * @name Log entries created from user input
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @id go/log-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-287
 */

import go
import semmle.go.security.LogInjection
import LogInjection::Flow::PathGraph

from LogInjection::Flow::PathNode source, LogInjection::Flow::PathNode sink
where LogInjection::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"

import go
import go.security.dataflow.TaintTracking as T

import LogSanitizer

class LogSink extends T.Sink {
  LogSink() { this = T.Sink("LogSink") }
}

from T.Source src, T.Sink sink, Function sanitizerFn
where
  src.flowsTo(sink) and
  not exists(sanitizerFn |
    isSanitizer(sanitizerFn) and
    src.flowsTo(sanitizerFn) and
    sanitizerFn.flowsTo(sink)
  )
select sink, "Possible unsanitized value logged (no sanitizer detected on flow)."