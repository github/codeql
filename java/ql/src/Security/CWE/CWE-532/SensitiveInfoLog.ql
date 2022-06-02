/**
 * @name Insertion of sensitive information into log files
 * @description Writing sensitive information to log files can allow that
 *              information to be leaked to an attacker more easily.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/sensitive-log
 * @tags security
 *       external/cwe/cwe-532
 */

import java
import semmle.code.java.security.SensitiveLoggingQuery
import PathGraph

from SensitiveLoggerConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This $@ is written to a log file.", source.getNode(),
  "potentially sensitive information"
