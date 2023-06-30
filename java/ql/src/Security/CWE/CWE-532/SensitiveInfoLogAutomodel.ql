/**
 * @name Insertion of sensitive information into log files
 * @description Writing sensitive information to log files can allow that
 *              information to be leaked to an attacker more easily.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/sensitive-log-automodel
 * @tags security
 *       external/cwe/cwe-532
 *       ai-generated
 */

import java
import semmle.code.java.security.SensitiveLoggingQuery
import SensitiveLoggerFlow::PathGraph
private import semmle.code.java.AutomodelSinkTriageUtils

from SensitiveLoggerFlow::PathNode source, SensitiveLoggerFlow::PathNode sink
where SensitiveLoggerFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This $@ is written to a log file." + getSinkModelQueryRepr(sink.getNode().asExpr()),
  source.getNode(), "potentially sensitive information"
