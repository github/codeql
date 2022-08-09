/**
 * Modeling for `railties`, which is a gem containing various internals and utilities for the Rails framework.
 * https://rubygems.org/gems/railties
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.ast.internal.Module

/**
 * Modeling for `railties`.
 */
module Railties {
  /**
   * A class which `include`s `Rails::Generators::Actions`.
   */
  private class GeneratorsActionsContext extends ClassDeclaration {
    GeneratorsActionsContext() {
      exists(IncludeOrPrependCall i |
        i.getEnclosingModule() = this and
        i.getArgument(0) =
          API::getTopLevelMember("Rails")
              .getMember("Generators")
              .getMember("Actions")
              .getAValueReachableFromSource()
              .asExpr()
              .getExpr()
      )
    }
  }

  /**
   * A call to `Rails::Generators::Actions#execute_command`.
   * This method concatenates its first and second arguments and executes the result as a shell command.
   */
  private class ExecuteCommandCall extends SystemCommandExecution::Range, DataFlow::CallNode {
    ExecuteCommandCall() {
      this.asExpr().getExpr().getEnclosingModule() instanceof GeneratorsActionsContext and
      this.getMethodName() = "execute_command"
    }

    override DataFlow::Node getAnArgument() { result = this.getArgument([0, 1]) }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
  }

  /**
   * A call to a method in `Rails::Generators::Actions` which delegates to `execute_command`.
   */
  private class ExecuteCommandWrapperCall extends SystemCommandExecution::Range, DataFlow::CallNode {
    ExecuteCommandWrapperCall() {
      this.asExpr().getExpr().getEnclosingModule() instanceof GeneratorsActionsContext and
      this.getMethodName() = ["rake", "rails_command", "git"]
    }

    override DataFlow::Node getAnArgument() { result = this.getArgument(0) }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
  }
}
