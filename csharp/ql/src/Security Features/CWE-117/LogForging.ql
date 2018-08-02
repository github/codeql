/**
 * @name Log entries created from user input
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/log-forging
 * @tags security
 *       external/cwe/cwe-117
 */
import csharp
import semmle.code.csharp.security.dataflow.LogForging::LogForging

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to log entry.", source, "User-provided value"
