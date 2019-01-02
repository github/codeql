/**
 * @name Improper control of generation of code
 * @description Treating externally controlled strings as code can allow an attacker to execute
 *              malicious code.
 * @kind path-problem
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
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is compiled as code.", source.getNode(),
  "User-provided value"
