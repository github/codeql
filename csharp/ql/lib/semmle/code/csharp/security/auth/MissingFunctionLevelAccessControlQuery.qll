/** Definitions for the missing function level access control query */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.web.UI
import semmle.code.asp.WebConfig

abstract class ActionMethod extends Method {
  string getADescription() {
    result =
      [
        this.getName(), this.getDeclaringType().getBaseClass*().getName(),
        this.getDeclaringType().getFile().getRelativePath()
      ]
  }

  predicate needsAuth() {
    this.getADescription().toLowerCase().regexpMatch(".*(edit|delete|modify|admin|superuser).*")
  }

  Callable getAnAuthorizingCallable() { result = this }
}

private class MvcActionMethod extends ActionMethod {
  MvcActionMethod() { this = any(MicrosoftAspNetCoreMvcController c).getAnActionMethod() }
}

private class WebFormActionMethod extends ActionMethod {
  WebFormActionMethod() {
    this.getDeclaringType().getBaseClass*() instanceof SystemWebUIPageClass and
    this.getAParameter().getType().getName().matches("%EventArgs")
  }

  override Callable getAnAuthorizingCallable() {
    result = this
    or
    result.getDeclaringType() = this.getDeclaringType() and
    result.getName() = "Page_Load"
  }
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

class AuthorizationXmlElement extends XmlElement {
  AuthorizationXmlElement() {
    this.getParent() instanceof SystemWebXmlElement and
    this.getName().toLowerCase() = "authorization"
  }

  predicate hasDenyElement() { this.getAChild().getName().toLowerCase() = "deny" }

  string getPhysicalPath() { result = this.getFile().getParentContainer().getRelativePath() }

  string getLocationTagPath() {
    exists(LocationXmlElement loc, XmlAttribute path |
      loc = this.getParent().(SystemWebXmlElement).getParent() and
      path = loc.getAnAttribute() and
      path.getName().toLowerCase() = "path" and
      result = path.getValue()
    )
  }
}

/**
 * Holds if the given action has an xml `authorization` tag that refers to it.
 * TODO: Currently only supports physical paths, however virtual paths defined by `AddRoute` can also be used.
 */
predicate hasAuthViaXml(ActionMethod m) {
  exists(AuthorizationXmlElement el, string path, string rest |
    path = (el.getPhysicalPath() + "/" + el.getLocationTagPath())
    or
    not exists(el.getLocationTagPath()) and
    path = el.getPhysicalPath()
  |
    el.hasDenyElement() and
    m.getDeclaringType().getFile().getRelativePath() = path + rest
  )
}

/** Holds if `m` is a method that should have an auth check, but is missing it. */
predicate missingAuth(ActionMethod m) {
  m.needsAuth() and
  not hasAuthViaCode(m)
}
