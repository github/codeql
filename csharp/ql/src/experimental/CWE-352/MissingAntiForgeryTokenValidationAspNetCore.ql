/**
 * @name Missing cross-site request forgery token validation
 * @description Handling a POST request without verifying that the request came from the user
 *              allows a malicious attacker to submit a request on behalf of the user.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id cs/web/missing-token-validation-aspnetcore
 * @tags security
 *       external/cwe/cwe-352
 *       experimental
 */

import csharp
import experimental.code.csharp.MissingAntiForgeryTokenValidationAspNetCore

from Method postMethod, Controller c
where
  postMethod = c.getAPostActionMethod() and
  // The method is not protected by a "validate anti forgery token" attribute (or ignores it)
  not methodHasCsrfAttribute(postMethod) and
  // the class of the method doesn't have a "validate anti forgery token" method (or ignores it)
  not controllerHasCsrfAttribute(c) and
  // a global anti forgery filter is not in use
  not hasGlobalAntiForgeryFilter()
select postMethod,
  "Method '" + postMethod.getName() +
    "' handles a POST request without performing CSRF token validation."
