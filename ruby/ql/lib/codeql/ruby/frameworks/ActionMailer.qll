/**
 * Provides modeling for the `ActionMailer` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.internal.Rails

/**
 * Provides modeling for the `ActionMailer` library.
 */
module ActionMailer {
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
  class MailerClass extends ClassDeclaration {
    MailerClass() {
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
  private class ContextCall extends MethodCall {
    private MailerClass mailerClass;

    ContextCall() {
      this.getReceiver() instanceof SelfVariableAccess and
      this.getEnclosingModule() = mailerClass
    }

    /** Gets the mailer class containing this method. */
    MailerClass getMailerClass() { result = mailerClass }
  }

  /** A call to `params` from within a mailer. */
  class ParamsCall extends ContextCall, ParamsCallImpl {
    ParamsCall() { this.getMethodName() = "params" }
  }
}
