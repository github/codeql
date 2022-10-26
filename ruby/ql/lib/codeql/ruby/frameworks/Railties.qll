/**
 * Modeling for `railties`, which is a gem containing various internals and utilities for the Rails framework.
 * https://rubygems.org/gems/railties
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow

/**
 * Modeling for `railties`.
 */
module Railties {
  private class IncludeOrPrependCall extends MethodCall {
    IncludeOrPrependCall() { this.getMethodName() = ["include", "prepend"] }
  }

  private DataFlow::ConstRef generatorsActionsConst() {
    result = DataFlow::getConst("Rails").getConst("Generators").getConst("Actions")
  }

  /**
   * Gets a class which is a descendent of `Rails::Generators::Actions`.
   */
  private DataFlow::ClassNode generatorsActionsClass() {
    result = generatorsActionsConst().getADescendentModule()
  }

  /**
   * A call to `Rails::Generators::Actions#execute_command`.
   * This method concatenates its first and second arguments and executes the result as a shell command.
   */
  private class ExecuteCommandCall extends SystemCommandExecution::Range, DataFlow::CallNode {
    ExecuteCommandCall() {
      this = generatorsActionsClass().getAnOwnInstanceSelf().getAMethodCall("execute_command")
    }

    override DataFlow::Node getAnArgument() { result = this.getArgument([0, 1]) }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
  }

  /**
   * A call to a method in `Rails::Generators::Actions` which delegates to `execute_command`.
   */
  private class ExecuteCommandWrapperCall extends SystemCommandExecution::Range, DataFlow::CallNode {
    ExecuteCommandWrapperCall() {
      this =
        generatorsActionsClass()
            .getAnOwnInstanceSelf()
            .getAMethodCall(["rake", "rails_command", "git"])
    }

    override DataFlow::Node getAnArgument() { result = this.getArgument(0) }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
  }
}
