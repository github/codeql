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
import codeql.ruby.frameworks.Gemfile

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

/**
 * Holds if the Gemfile for this application specifies a version of "rails" < 3.0.0.
 * Rails versions from 3.0.0 onwards enable CSRF protection by default.
 */
private predicate railsPreVersion3() {
  exists(Gemfile::Gem g | g.getName() = "rails" and g.getAVersionConstraint().before("5.2"))
}

from ActionControllerClass c
where
  not protectFromForgeryCall(_, c, _) and
  // Rails versions prior to 3.0.0 require CSRF protection to be explicitly enabled.
  // For later versions, there must exist a call to `csrf_meta_tags` in every HTML response.
  // We currently just check for a call to this method anywhere in the codebase.
  (
    railsPreVersion3()
    or
    not any(MethodCall m).getMethodName() = ["csrf_meta_tags", "csrf_meta_tag"]
  )
select c, "Potential CSRF vulnerability due to forgery protection not being enabled."
