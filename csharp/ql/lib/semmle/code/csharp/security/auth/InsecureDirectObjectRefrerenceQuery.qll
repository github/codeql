/** Definitions for the Insecure Direct Object Reference query */

import csharp
import semmle.code.csharp.dataflow.flowsources.Remote
import ActionMethods

/**
 * Holds if `m` is a method that may require checks
 * against the current user to modify a particular resource.
 */
// We exclude admin methods as it may be expected that an admin user should be able to modify any resource.
// Other queries check that there are authorization checks in place for admin methods.
private predicate needsChecks(ActionMethod m) { m.isEdit() and not m.isAdmin() }

private Expr getParentExpr(Expr ex) { result = ex.getParent() }

/**
 * Holds if `m` has a parameter or access a remote flow source
 * that may indicate that it's used as the ID for some resource
 */
private predicate hasIdParameter(ActionMethod m) {
  exists(RemoteFlowSource src | src.getEnclosingCallable() = m |
    src.asParameter().getName().toLowerCase().matches(["%id", "%idx"])
    or
    exists(StringLiteral idStr |
      idStr.getValue().toLowerCase().matches(["%id", "%idx"]) and
      getParentExpr*(src.asExpr()) = getParentExpr*(idStr)
    )
  )
}

/** Holds if `m` at some point in its call graph may make some kind of check against the current user. */
private predicate checksUser(ActionMethod m) {
  exists(Property p | p.getName().toLowerCase().matches(["%user%", "%session%"]) |
    m.calls*(p.getGetter())
  )
}

/**
 * Holds if `m` is a method that modifies a particular resource based on
 * and ID provided by user input, but does not check anything based on the current user
 * to determine if they should modify this resource.
 */
predicate hasInsecureDirectObjectReference(ActionMethod m) {
  needsChecks(m) and
  hasIdParameter(m) and
  not checksUser(m) and
  exists(m.getBody())
}
