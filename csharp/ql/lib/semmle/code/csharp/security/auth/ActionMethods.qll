/** Common definitions for queries checking for access control measures on action methods. */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.web.UI

/** A method representing an action for a web endpoint. */
abstract class ActionMethod extends Method {
  /**
   * Gets a string that can indicate what this method does to determine if it should have an auth check;
   * such as its method name, class name, or file path.
   */
  string getADescription() {
    result = [this.getName(), this.getDeclaringType().getBaseClass*().getName(), this.getARoute()]
  }

  /** Holds if this method may represent a stateful action such as editing or deleting */
  predicate isEdit() {
    exists(string str |
      str =
        this.getADescription()
            // separate camelCase words
            .regexpReplaceAll("([a-z])([A-Z])", "$1_$2") and
      str.regexpMatch("(?i).*(edit|delete|modify|change).*") and
      not str.regexpMatch("(?i).*(on_?change|changed).*")
    )
  }

  /** Holds if this method may be intended to be restricted to admin users */
  predicate isAdmin() {
    this.getADescription()
        // separate camelCase words
        .regexpReplaceAll("([a-z])([A-Z])", "$1_$2")
        .regexpMatch("(?i).*(admin|superuser).*")
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
    pageLoad(result, this.getDeclaringType())
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

pragma[nomagic]
private predicate pageLoad(Callable c, Type decl) {
  c.getName() = "Page_Load" and
  decl = c.getDeclaringType()
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
        .hasFullyQualifiedName("System.Web.Routing", "RouteCollection", "MapPageRoute") and
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
