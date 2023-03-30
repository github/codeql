/**
 * @name Use of externally-controlled format string
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/tainted-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import java
import semmle.code.java.security.ExternallyControlledFormatStringQuery
import semmle.code.java.StringFormat
import ExternallyControlledFormatStringFlow::PathGraph

from
  ExternallyControlledFormatStringFlow::PathNode source,
  ExternallyControlledFormatStringFlow::PathNode sink, StringFormat formatCall
where
  ExternallyControlledFormatStringFlow::flowPath(source, sink) and
  sink.getNode().asExpr() = formatCall.getFormatArgument()
select formatCall.getFormatArgument(), source, sink, "Format string depends on a $@.",
  source.getNode(), "user-provided value"
