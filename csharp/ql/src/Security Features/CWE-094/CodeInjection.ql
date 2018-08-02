/**
 * @name Improper control of generation of code
 * @description Treating externally controlled strings as code can allow an attacker to execute
 *              malicious code.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/code-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-096
 */
import csharp
import semmle.code.csharp.security.dataflow.CodeInjection::CodeInjection

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is compiled as code.", source, "User-provided value"
