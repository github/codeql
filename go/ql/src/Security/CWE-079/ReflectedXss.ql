/**
 * @name Reflected cross-site scripting
 * @description Writing user input directly to an HTTP response allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id go/reflected-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import go
import semmle.go.security.ReflectedXss
import ReflectedXss::Flow::PathGraph

from
  ReflectedXss::Flow::PathNode source, ReflectedXss::Flow::PathNode sink, string msg, string part,
  Locatable partloc
where
  ReflectedXss::Flow::flowPath(source, sink) and
  (
    exists(string kind | kind = sink.getNode().(SharedXss::Sink).getSinkKind() |
      kind = "rawtemplate" and
      msg = "Cross-site scripting vulnerability due to $@. The value is $@." and
      part = "instantiated as a raw template"
    )
    or
    not exists(sink.getNode().(SharedXss::Sink).getSinkKind()) and
    msg = "Cross-site scripting vulnerability due to $@." and
    part = ""
  ) and
  partloc = sink.getNode().(SharedXss::Sink).getAssociatedLoc()
select sink.getNode(), source, sink, msg, source.getNode(), "user-provided value", partloc, part
