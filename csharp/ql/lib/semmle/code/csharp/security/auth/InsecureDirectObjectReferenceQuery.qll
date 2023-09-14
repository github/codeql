/** Definitions for the Insecure Direct Object Reference query */

import csharp
import semmle.code.csharp.dataflow.flowsources.Remote
import DataFlow as DF
import TaintTracking as TT
import ActionMethods

/**
 * Holds if `m` is a method that may require checks
 * against the current user to modify a particular resource.
 */
// We exclude admin methods as it may be expected that an admin user should be able to modify any resource.
// Other queries check that there are authorization checks in place for admin methods.
private predicate needsChecks(ActionMethod m) { m.isEdit() and not m.isAdmin() }

/**
 * Holds if `m` has a parameter or access a remote flow source
 * that may indicate that it's used as the ID for some resource
 */
private predicate hasIdParameter(ActionMethod m) {
  exists(RemoteFlowSource src | src.getEnclosingCallable() = m |
    src.asParameter().getName().toLowerCase().matches(["%id", "%idx"])
    or
    // handle cases like `Request.QueryString["Id"]`
    exists(StringLiteral idStr, IndexerCall idx |
      idStr.getValue().toLowerCase().matches(["%id", "%idx"]) and
      TT::localTaint(src, DataFlow::exprNode(idx.getQualifier())) and
      DF::localExprFlow(idStr, idx.getArgument(0))
    )
  )
}

/** Holds if `m` at some point in its call graph may make some kind of check against the current user. */
private predicate checksUser(ActionMethod m) {
  exists(Callable c, string name | name = c.getName().toLowerCase() |
    name.matches(["%user%", "%session%"]) and
    not name.matches("%get%by%") and // methods like `getUserById` or `getXByUsername` aren't likely to be referring to the current user
    m.calls*(c)
  )
}

/** Holds if `m`, its containing class, or a parent class has an attribute that extends `AuthorizeAttribute` */
private predicate hasAuthorizeAttribute(ActionMethod m) {
  exists(Attribute attr |
    attr.getType()
        .getABaseType*()
        .hasQualifiedName([
            "Microsoft.AspNetCore.Authorization", "System.Web.Mvc", "System.Web.Http"
          ], "AuthorizeAttribute")
  |
    attr = m.getOverridee*().getAnAttribute() or
    attr = m.getDeclaringType().getABaseType*().getAnAttribute()
  )
}

/** Holds if `m`, its containing class, or a parent class has an attribute that extends `AllowAnonymousAttribute` */
private predicate hasAllowAnonymousAttribute(ActionMethod m) {
  exists(Attribute attr |
    attr.getType()
        .getABaseType*()
        .hasQualifiedName([
            "Microsoft.AspNetCore.Authorization", "System.Web.Mvc", "System.Web.Http"
          ], "AllowAnonymousAttribute")
  |
    attr = m.getOverridee*().getAnAttribute() or
    attr = m.getDeclaringType().getABaseType*().getAnAttribute()
  )
}

/** Holds if `m` is authorized via an `Authorize` attribute */
private predicate isAuthorizedViaAttribute(ActionMethod m) {
  hasAuthorizeAttribute(m) and
  not hasAllowAnonymousAttribute(m)
}

/**
 * Holds if `m` is a method that modifies a particular resource based on
 * an ID provided by user input, but does not check anything based on the current user
 * to determine if they should modify this resource.
 */
predicate hasInsecureDirectObjectReference(ActionMethod m) {
  needsChecks(m) and
  hasIdParameter(m) and
  not checksUser(m) and
  not isAuthorizedViaAttribute(m) and
  exists(m.getBody().getAChildStmt())
}
