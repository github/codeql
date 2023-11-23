/** Definitions for the missing function level access control query */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.web.UI
import semmle.code.asp.WebConfig
import ActionMethods

/** Holds if the method `m` may need an authorization check. */
predicate needsAuth(ActionMethod m) { m.isEdit() or m.isAdmin() }

/** An expression that indicates that some authorization/authentication check is being performed. */
class AuthExpr extends Expr {
  AuthExpr() {
    this.(MethodCall)
        .getTarget()
        .hasFullyQualifiedName("System.Security.Principal", "IPrincipal", "IsInRole")
    or
    this.(PropertyAccess)
        .getTarget()
        .hasFullyQualifiedName("System.Security.Principal", "IIdentity", ["IsAuthenticated", "Name"])
    or
    this.(MethodCall).getTarget().getName().toLowerCase().matches("%auth%")
    or
    this.(PropertyAccess).getTarget().getName().toLowerCase().matches("%auth%")
  }
}

/** Holds if `m` is a method that should have an auth check, and does indeed have one. */
predicate hasAuthViaCode(ActionMethod m) {
  needsAuth(m) and
  exists(Callable caller, AuthExpr auth |
    m.getAnAuthorizingCallable().calls*(caller) and
    auth.getEnclosingCallable() = caller
  )
}

/** An `<authorization>` XML element. */
class AuthorizationXmlElement extends XmlElement {
  AuthorizationXmlElement() {
    this.getParent() instanceof SystemWebXmlElement and
    this.getName().toLowerCase() = "authorization"
  }

  /** Holds if this element has a `<deny>` element to deny access to a resource. */
  predicate hasDenyElement() { this.getAChild().getName().toLowerCase() = "deny" }

  /** Gets the physical filepath of this element. */
  string getPhysicalPath() { result = this.getFile().getParentContainer().getRelativePath() }

  /** Gets the path specified by a `<location>` tag containing this element, if any. */
  string getLocationTagPath() {
    exists(LocationXmlElement loc, XmlAttribute path |
      loc = this.getParent().(SystemWebXmlElement).getParent() and
      path = loc.getAnAttribute() and
      path.getName().toLowerCase() = "path" and
      result = path.getValue()
    )
  }

  /** Gets a route prefix that this configuration can refer to. */
  string getARoute() {
    result = this.getLocationTagPath()
    or
    result = this.getPhysicalPath() + "/" + this.getLocationTagPath()
    or
    not exists(this.getLocationTagPath()) and
    result = this.getPhysicalPath()
  }
}

/**
 * Holds if the given action has an xml `authorization` tag that refers to it.
 */
predicate hasAuthViaXml(ActionMethod m) {
  exists(AuthorizationXmlElement el, string rest |
    el.hasDenyElement() and
    m.getARoute() = el.getARoute() + rest
  )
}

/** Holds if the given action has an attribute that indications authorization. */
predicate hasAuthViaAttribute(ActionMethod m) {
  exists(Attribute attr | attr.getType().getName().toLowerCase().matches("%auth%") |
    attr = m.getOverridee*().getAnAttribute() or
    attr = getAnUnboundBaseType*(m.getDeclaringType()).getAnAttribute()
  )
}

private ValueOrRefType getAnUnboundBaseType(ValueOrRefType t) {
  result = t.getABaseType().getUnboundDeclaration()
}

/** Holds if `m` is a method that should have an auth check, but is missing it. */
predicate missingAuth(ActionMethod m) {
  needsAuth(m) and
  not hasAuthViaCode(m) and
  not hasAuthViaXml(m) and
  not hasAuthViaAttribute(m) and
  exists(m.getBody().getAChildStmt()) // exclude empty methods
}
