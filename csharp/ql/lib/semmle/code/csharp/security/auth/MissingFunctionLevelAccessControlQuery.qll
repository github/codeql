/** Definitions for the missing function level access control query */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.web.UI
import semmle.code.asp.WebConfig

/** A method representing an action for a web endpoint. */
abstract class ActionMethod extends Method {
  /**
   * Gets a string that can indicate what this method does to determine if it should have an auth check;
   * such as its method name, class name, or file path.
   */
  string getADescription() {
    result =
      [
        this.getName(), this.getDeclaringType().getBaseClass*().getName(),
        this.getDeclaringType().getFile().getRelativePath()
      ]
  }

  /** Holds if this method may need an authorization check. */
  predicate needsAuth() {
    this.getADescription()
        .regexpReplaceAll("([a-z])([A-Z])", "$1_$2")
        // separate camelCase words
        .toLowerCase()
        .regexpMatch(".*(edit|delete|modify|admin|superuser).*")
  }

  /** Gets a callable for which if it contains an auth check, this method should be considered authenticated. */
  Callable getAnAuthorizingCallable() { result = this }

  /**
   * Gets a possible url route that could refer to this action,
   * which would be covered by `<location>` configurations specifying a prefix of it.
   */
  string getARoute() { result = this.getDeclaringType().getFile().getRelativePath() }
}

/** An action method in the MVC framework. */
private class MvcActionMethod extends ActionMethod {
  MvcActionMethod() { this = any(MicrosoftAspNetCoreMvcController c).getAnActionMethod() }
}

/** An action method on a subclass of `System.Web.UI.Page`. */
private class WebFormActionMethod extends ActionMethod {
  WebFormActionMethod() {
    this.getDeclaringType().getBaseClass+() instanceof SystemWebUIPageClass and
    this.getAParameter().getType().getName().matches("%EventArgs")
  }

  override Callable getAnAuthorizingCallable() {
    result = super.getAnAuthorizingCallable()
    or
    result.getDeclaringType() = this.getDeclaringType() and
    result.getName() = "Page_Load"
  }

  override string getARoute() {
    exists(string physicalRoute | physicalRoute = super.getARoute() |
      result = physicalRoute
      or
      exists(string absolutePhysical |
        virtualRouteMapping(result, absolutePhysical) and
        physicalRouteMatches(absolutePhysical, physicalRoute)
      )
    )
  }
}

/**
 * Holds if `virtualRoute` is a URL path
 * that can map to the corresponding `physicalRoute` filepath
 * through a call to `MapPageRoute`
 */
private predicate virtualRouteMapping(string virtualRoute, string physicalRoute) {
  exists(MethodCall mapPageRouteCall, StringLiteral virtualLit, StringLiteral physicalLit |
    mapPageRouteCall
        .getTarget()
        .hasQualifiedName("System.Web.Routing", "RouteCollection", "MapPageRoute") and
    virtualLit = mapPageRouteCall.getArgument(1) and
    physicalLit = mapPageRouteCall.getArgument(2) and
    virtualLit.getValue() = virtualRoute and
    physicalLit.getValue() = physicalRoute
  )
}

/** Holds if the filepath `route` can refer to `actual` after expanding a '~". */
bindingset[route, actual]
private predicate physicalRouteMatches(string route, string actual) {
  route = actual
  or
  route.charAt(0) = "~" and
  exists(string dir | actual = dir + route.suffix(1) + ".cs")
}

/** An expression that indicates that some authorization/authentication check is being performed. */
class AuthExpr extends Expr {
  AuthExpr() {
    this.(MethodCall)
        .getTarget()
        .hasQualifiedName("System.Security.Principal", "IPrincipal", "IsInRole")
    or
    this.(PropertyAccess)
        .getTarget()
        .hasQualifiedName("System.Security.Principal", "IIdentity", ["IsAuthenticated", "Name"])
    or
    this.(MethodCall).getTarget().getName().toLowerCase().matches("%auth%")
    or
    this.(PropertyAccess).getTarget().getName().toLowerCase().matches("%auth%")
  }
}

/** Holds if `m` is a method that should have an auth check, and does indeed have one. */
predicate hasAuthViaCode(ActionMethod m) {
  m.needsAuth() and
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
    attr = m.getAnAttribute() or
    attr = m.getDeclaringType().getABaseType*().getAnAttribute()
  )
}

/** Holds if `m` is a method that should have an auth check, but is missing it. */
predicate missingAuth(ActionMethod m) {
  m.needsAuth() and
  not hasAuthViaCode(m) and
  not hasAuthViaXml(m) and
  not hasAuthViaAttribute(m) and
  exists(m.getBody().getAChildStmt()) // exclude empty methods
}
