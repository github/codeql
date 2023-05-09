/** Definitions for the missing function level access control query */

import csharp
import semmle.code.csharp.frameworks.microsoft.AspNetCore
import semmle.code.csharp.frameworks.system.web.UI

/** Holds if `m` is a method representing an action whose name indicates that it should have some authorization/authentication check. */
predicate needsAuth(Method m) {
  (
    m = any(MicrosoftAspNetCoreMvcController c).getAnActionMethod()
    or
    m.getDeclaringType().getBaseClass*() instanceof SystemWebUIPageClass and
    m.getAParameter().getType().getName().matches("%EventArgs")
  ) and
  exists(string name |
    name =
      [
        m.getName(), m.getDeclaringType().getBaseClass*().getName(),
        m.getDeclaringType().getFile().getRelativePath()
      ] and
    name.toLowerCase().regexpMatch(".*(edit|delete|modify|admin|superuser).*")
  )
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
predicate hasAuth(Method m) {
  needsAuth(m) and
  exists(Method om, Callable caller, AuthExpr auth |
    om = m
    or
    om.getDeclaringType() = m.getDeclaringType() and
    om.getName() = "Page_Load"
  |
    om.calls*(caller) and
    auth.getEnclosingCallable() = caller
  )
}

/** Holds if `m` is a method that should have an auth check, but is missing it. */
predicate missingAuth(Method m) {
  needsAuth(m) and
  not hasAuth(m)
}
