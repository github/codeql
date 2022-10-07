/**
 * Provides modeling for the `ActionMailer` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.internal.Rails

/**
 * A `ClassDeclaration` for a class that extends `ActionMailer::Base`.
 * For example,
 *
 * ```rb
 * class FooMailer < ActionMailer::Base
 *   ...
 * end
 * ```
 */
class ActionMailerMailerClass extends ClassDeclaration {
  ActionMailerMailerClass() {
    this.getSuperclassExpr() =
      [
        API::getTopLevelMember("ActionMailer").getMember("Base"),
        // In Rails applications `ApplicationMailer` typically extends
        // `ActionMailer::Base`, but we treat it separately in case the
        // `ApplicationMailer` definition is not in the database.
        API::getTopLevelMember("ApplicationMailer")
      ].getASubclass().getAValueReachableFromSource().asExpr().getExpr()
  }
}

/** A method call with a `self` receiver from within a mailer class */
private class ActionMailerContextCall extends MethodCall {
  private ActionMailerMailerClass mailerClass;

  ActionMailerContextCall() {
    this.getReceiver() instanceof SelfVariableAccess and
    this.getEnclosingModule() = mailerClass
  }

  /** Gets the mailer class containing this method. */
  ActionMailerMailerClass getMailerClass() { result = mailerClass }
}

/** A call to `params` from within a mailer. */
class ActionMailerParamsCall extends ActionMailerContextCall, ParamsCallImpl {
  ActionMailerParamsCall() { this.getMethodName() = "params" }
}
