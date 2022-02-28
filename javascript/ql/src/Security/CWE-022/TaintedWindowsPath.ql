/**
 * @name Uncontrolled data used in path expression (Posix and Win32)
 * @description Accessing paths influenced by users can allow an attacker to access
 *              unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/path-injection-win32-enabled
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import javascript
import semmle.javascript.security.dataflow.TaintedPathQuery
import semmle.javascript.security.dataflow.TaintedPathCustomizations
import DataFlow::PathGraph
import semmle.javascript.frameworks.NodeJSLib

class Win32Platform extends Path::Platform {
  Win32Platform() { this = Path::platformWin32() }

  override string getSep() { result = "\\" }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on $@.", source.getNode(),
  "a user-provided value"
