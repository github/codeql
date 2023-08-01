/** Definitions for the Insecure Direct Object Reference query */

import csharp
import semmle.code.csharp.dataflow.flowsources.Remote
import ActionMethods

private predicate needsChecks(ActionMethod m) { m.isEdit() and not m.isAdmin() }

private predicate hasIdParameter(ActionMethod m) {
  exists(RemoteFlowSource src | src.getEnclosingCallable() = m |
    src.asParameter().getName().toLowerCase().matches("%id")
    or
    exists(StringLiteral idStr |
      idStr.getValue().toLowerCase().matches("%id") and
      idStr.getParent*() = src.asExpr()
    )
  )
}

private predicate checksUser(ActionMethod m) {
  exists(Callable c | c.getName().toLowerCase().matches("%user%") | m.calls*(c))
}

predicate hasInsecureDirectObjectReference(ActionMethod m) {
  needsChecks(m) and
  hasIdParameter(m) and
  not checksUser(m)
}
