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

from Configuration cfg, Source source, DataFlow::Node sink
where cfg.hasFlow(source, sink) and
      // ignore logging to the browser console (even though it is not a good practice)
      not inBrowserEnvironment(sink.asExpr().getTopLevel())
select sink, "Sensitive data returned by $@ is logged here.", source, source.describe()
