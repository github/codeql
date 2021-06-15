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

/** An `AuthorizationFilter` that calls the `AntiForgery.Validate` method. */
class AntiForgeryAuthorizationFilter extends AuthorizationFilter {
  AntiForgeryAuthorizationFilter() {
    getOnAuthorizationMethod().calls*(any(AntiForgeryClass a).getValidateMethod())
  }
}

/**
 * Holds if the project has a global anti forgery filter.
 */
predicate hasGlobalAntiForgeryFilter() {
  // A global filter added
  exists(MethodCall addGlobalFilter |
    // addGlobalFilter adds a filter to the global filter collection
    addGlobalFilter.getTarget() = any(GlobalFilterCollection gfc).getAddMethod() and
    // The filter is an antiforgery filter
    addGlobalFilter.getArgumentForName("filter").getType() instanceof AntiForgeryAuthorizationFilter and
    // The filter is added by the Application_Start() method
    any(WebApplication wa)
        .getApplication_StartMethod()
        .calls*(addGlobalFilter.getEnclosingCallable())
  )
}

from Controller c, Method postMethod
where
  postMethod = c.getAPostActionMethod() and
  // The method is not protected by a validate anti forgery token attribute
  not postMethod.getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute and
  not c.getAnAttribute() instanceof ValidateAntiForgeryTokenAttribute and
  // Verify that validate anti forgery token attributes are used somewhere within this project, to
  // avoid reporting false positives on projects that use an alternative approach to mitigate CSRF
  // issues.
  exists(ValidateAntiForgeryTokenAttribute a, Element e | e = a.getTarget()) and
  // Also ignore cases where a global anti forgery filter is in use.
  not hasGlobalAntiForgeryFilter()
select postMethod,
  "Method '" + postMethod.getName() +
    "' handles a POST request without performing CSRF token validation."
