/**
 * @name CSRF protection not enabled
 * @description Not enabling CSRF protection may make the application
 *              vulnerable to a Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision high
 * @id rb/csrf-protection-not-enabled
 * @tags security
 *       external/cwe/cwe-352
 */

import codeql.ruby.AST
import codeql.ruby.Concepts
import codeql.ruby.frameworks.ActionController

/**
 * Holds if a call to `protect_from_forgery` is made in the controller class `definedIn`,
 * which is inherited by the controller class `child`.
 */
private predicate protectFromForgeryCall(
  ActionControllerClass definedIn, ActionControllerClass child,
  ActionController::ProtectFromForgeryCall call
) {
  definedIn.getSelf().flowsTo(call.getReceiver()) and child = definedIn.getADescendent()
}

from ActionControllerClass c
where not protectFromForgeryCall(_, c, _)
select c, "Potential CSRF vulnerability due to forgery protection not being enabled."
