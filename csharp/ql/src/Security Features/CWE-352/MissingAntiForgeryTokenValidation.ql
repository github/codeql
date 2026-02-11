/**
 * @name Missing cross-site request forgery token validation
 * @description Handling a POST request without verifying that the request came from the user
 *              allows a malicious attacker to submit a request on behalf of the user.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id cs/web/missing-token-validation
 * @tags security
 *       external/cwe/cwe-352
 */

import csharp
import semmle.code.csharp.frameworks.system.Web
import semmle.code.csharp.frameworks.system.web.Helpers
import semmle.code.csharp.frameworks.system.web.Mvc
import semmle.code.csharp.frameworks.microsoft.AspNetCore as AspNetCore

private Method getAValidatingMethod() {
  result = any(AntiForgeryClass a).getValidateMethod()
  or
  result.calls(getAValidatingMethod())
}

/** An `AuthorizationFilter` that calls the `AntiForgery.Validate` method. */
class AntiForgeryAuthorizationFilter extends AuthorizationFilter {
  AntiForgeryAuthorizationFilter() { this.getOnAuthorizationMethod() = getAValidatingMethod() }
}

private Method getAStartedMethod() {
  result = any(WebApplication wa).getApplication_StartMethod()
  or
  getAStartedMethod().calls(result)
}

/**
 * Holds if the project has a global anti forgery filter.
 *
 * No AspNetCore case here as the corresponding class doesn't seem to exist.
 */
predicate hasGlobalAntiForgeryFilter() {
  // A global filter added
  exists(MethodCall addGlobalFilter |
    // addGlobalFilter adds a filter to the global filter collection
    addGlobalFilter.getTarget() = any(GlobalFilterCollection gfc).getAddMethod() and
    // The filter is an antiforgery filter
    addGlobalFilter.getArgumentForName("filter").getType() instanceof AntiForgeryAuthorizationFilter and
    // The filter is added by the Application_Start() method
    getAStartedMethod() = addGlobalFilter.getEnclosingCallable()
  )
}

predicate isUnvalidatedPostMethod(Class c, Method m) {
  c.(Controller).getAPostActionMethod() = m and
  not m.getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute and
  not c.getABaseType*().getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute
  or
  c.(AspNetCore::MicrosoftAspNetCoreMvcController).getAnActionMethod() = m and
  m.getAnAttribute() instanceof AspNetCore::MicrosoftAspNetCoreMvcHttpPostAttribute and
  not m.getAnAttribute() instanceof AspNetCore::ValidateAntiForgeryAttribute and
  not c.getABaseType*().getAnAttribute() instanceof AspNetCore::ValidateAntiForgeryAttribute
}

Element getAValidatedElement() {
  any(ValidateAntiForgeryTokenAttribute a).getTarget() = result
  or
  any(AspNetCore::ValidateAntiForgeryAttribute a).getTarget() = result
}

from Class c, Method postMethod
where
  isUnvalidatedPostMethod(c, postMethod) and
  // Verify that validate anti forgery token attributes are used somewhere within this project, to
  // avoid reporting false positives on projects that use an alternative approach to mitigate CSRF
  // issues.
  exists(getAValidatedElement()) and
  // Also ignore cases where a global anti forgery filter is in use.
  not hasGlobalAntiForgeryFilter()
select postMethod,
  "Method '" + postMethod.getName() +
    "' handles a POST request without performing CSRF token validation."
