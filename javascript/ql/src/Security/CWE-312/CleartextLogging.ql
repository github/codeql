/**
 * @name Clear-text logging of sensitive information
 * @description Logging sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/clear-text-logging
 * @tags security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import javascript
import semmle.javascript.security.dataflow.CleartextLogging::CleartextLogging
import DataFlow::PathGraph

/**
 * Holds if `tl` is used in a browser environment.
 */
predicate inBrowserEnvironment(TopLevel tl) {
  tl instanceof InlineScript
  or
  tl instanceof CodeInAttribute
  or
  exists(GlobalVarAccess e | e.getTopLevel() = tl | e.getName() = "window")
  or
  exists(Module m | inBrowserEnvironment(m) |
    tl = m.getAnImportedModule() or
    m = tl.(Module).getAnImportedModule()
  )
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  // ignore logging to the browser console (even though it is not a good practice)
  not inBrowserEnvironment(sink.getNode().asExpr().getTopLevel())
select sink.getNode(), source, sink, "Sensitive data returned by $@ is logged here.",
  source.getNode(), source.getNode().(Source).describe()
