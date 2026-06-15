/**
 * Provides modeling for the `ActionMailer` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.frameworks.internal.Rails

/**
 * Provides modeling for the `ActionMailer` library.
 */
module ActionMailer {
  private DataFlow::ClassNode actionMailerClass() {
    result =
      [
        DataFlow::getConstant("ActionMailer").getConstant("Base"),
        // In Rails applications `ApplicationMailer` typically extends
        // `ActionMailer::Base`, but we treat it separately in case the
        // `ApplicationMailer` definition is not in the database.
        DataFlow::getConstant("ApplicationMailer")
      ].getADescendentModule()
  }

  private API::Node actionMailerInstance() { result = actionMailerClass().trackInstance() }

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
    MailerClass() { this = actionMailerClass().getADeclaration() }
  }

  /** A call to `params` from within a mailer. */
  class ParamsCall extends ParamsCallImpl {
    ParamsCall() { this = actionMailerInstance().getAMethodCall("params").asExpr().getExpr() }
  }
}
