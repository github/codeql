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
import codeql.ruby.DataFlow

/**
 * Holds if a call to `protect_from_forgery` is made in the controller class `definedIn`,
 * which is inherited by the controller class `child`. These classes may be the same.
 */
private predicate protectFromForgeryCall(
  ActionControllerClass definedIn, ActionControllerClass child,
  ActionController::ProtectFromForgeryCall call
) {
  definedIn.getSelf().flowsTo(call.getReceiver()) and child = definedIn.getADescendent()
}

/**
 * Holds if the Gemfile for this application specifies a version of "rails" or "actionpack" < 5.2.
 * Rails versions prior to 5.2 do not enable CSRF protection by default.
 */
private predicate railsPreVersion5_2() {
  exists(Gemfile::Gem g |
    g.getName() = ["rails", "actionpack"] and g.getAVersionConstraint().before("5.2")
  )
}

private float getRailsConfigDefaultVersion() {
  exists(DataFlow::CallNode config, DataFlow::CallNode loadDefaultsCall |
    DataFlow::getConstant("Rails")
        .getConstant("Application")
        .getADescendentModule()
        .getAnImmediateReference()
        .flowsTo(config.getReceiver()) and
    config.getMethodName() = "config" and
    loadDefaultsCall.getReceiver() = config and
    loadDefaultsCall.getMethodName() = "load_defaults" and
    result = loadDefaultsCall.getArgument(0).getConstantValue().getFloat()
  )
}

from ActionControllerClass c
where
  not protectFromForgeryCall(_, c, _) and
  (
    // Rails versions prior to 5.2 require CSRF protection to be explicitly enabled.
    railsPreVersion5_2()
    or
    // For Rails >= 5.2, CSRF protection is enabled by default if there is a `load_defaults` call in the root application class
    // which specifies a version >= 5.2.
    not getRailsConfigDefaultVersion() >= 5.2
  ) and
  // Only generate alerts for the topmost controller in the tree.
  not exists(ActionControllerClass parent | c = parent.getAnImmediateDescendent())
select c, "Potential CSRF vulnerability due to forgery protection not being enabled."
