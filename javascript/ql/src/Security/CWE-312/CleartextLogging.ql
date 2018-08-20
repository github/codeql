/**
 * @name Clear-text logging of sensitive information
 * @description Logging sensitive information without encryption or hashing can
 *              expose it to an attacker.
 * @kind problem
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

/**
 * Holds if `tl` is used in a browser environment.
 */
predicate inBrowserEnvironment(TopLevel tl) {
  tl instanceof InlineScript or
  tl instanceof CodeInAttribute or
  exists (GlobalVarAccess e |
    e.getTopLevel() = tl |
    e.getName() = "window"
  ) or
  exists (Module m | inBrowserEnvironment(m) |
    tl = m.getAnImportedModule() or
    m = tl.(Module).getAnImportedModule()
  )
}

/**
 * Holds if `sink` only is reachable in a "test" environment.
 */
predicate inTestEnvironment(Sink sink) {
  exists (IfStmt guard, Identifier id |
    // heuristic: a deliberate environment choice by the programmer related to passwords implies a test environment
    id.getName().regexpMatch("(?i).*(test|develop|production).*") and
    id.(Expr).getParentExpr*() = guard.getCondition() and
    (
      guard.getAControlledStmt() = sink.asExpr().getEnclosingStmt() or
      guard.getAControlledStmt().(BlockStmt).getAChildStmt() = sink.asExpr().getEnclosingStmt()
    )
  )
}

from Configuration cfg, Source source, DataFlow::Node sink
where cfg.hasFlow(source, sink) and
      // ignore logging to the browser console (even though it is not a good practice)
      not inBrowserEnvironment(sink.asExpr().getTopLevel()) and
      // ignore logging when testing
      not inTestEnvironment(sink)
select sink, "Sensitive data returned by $@ is logged here.", source, source.describe()
