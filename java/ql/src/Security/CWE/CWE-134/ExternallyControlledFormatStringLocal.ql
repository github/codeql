/**
 * @name Use of externally-controlled format string from local source
 * @description Using external input in format strings can lead to exceptions or information leaks.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 9.3
 * @precision medium
 * @id java/tainted-format-string-local
 * @tags security
 *       external/cwe/cwe-134
 */

import java
import semmle.code.java.StringFormat
import semmle.code.java.security.ExternallyControlledFormatStringLocalQuery
import ExternallyControlledFormatStringLocalFlow::PathGraph

from
  ExternallyControlledFormatStringLocalFlow::PathNode source,
  ExternallyControlledFormatStringLocalFlow::PathNode sink, StringFormat formatCall
where
  ExternallyControlledFormatStringLocalFlow::flowPath(source, sink) and
  sink.getNode().asExpr() = formatCall.getFormatArgument()
select formatCall.getFormatArgument(), source, sink, "Format string depends on a $@.",
  source.getNode(), "user-provided value"
