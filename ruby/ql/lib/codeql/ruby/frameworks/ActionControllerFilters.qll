private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate

module ActionControllerFilters {
  class ActionControllerFilterConfigCall extends MethodCallCfgNode {
    private ActionControllerClass controller;
    private ModuleBase enclosingModule;

    ActionControllerFilterConfigCall() {
      this.getExpr().getEnclosingModule() = enclosingModule and
      enclosingModule = controller.getADeclaration() and
      this.getMethodName() =
        ["", "prepend_", "append"] + ["before_action", "after_action", "around_action"]
    }

    string getFilterName() { result = this.getArgument(0).getConstantValue().getStringlikeValue() }

    ModuleBase getEnclosingModule() { result = enclosingModule }

    /**
     * Gets the callable that implements this filter.
     * This currently only finds methods in the local class or superclass, or inline blocks.
     * It doesn't handle:
     * - lambdas
     * - blocks
     * - classes
     *
     * In the example below, the callable for the filter is the method `foo`.
     * ```rb
     * class PostsController < ActionController::Base
     *   before_action :foo
     *
     *   def foo
     *   end
     * end
     * ```
     */
    Callable getFilterCallable() {
      result.(MethodBase).getName() = this.getFilterName() and
      // Method in same class
      (
        result.getEnclosingModule() = this.getEnclosingModule()
        or
        // Method in superclass
        result.getEnclosingModule().getModule() =
          this.getEnclosingModule().getModule().getSuperClass()
      )
    }

    string getOnlyArgument() {
      exists(ExprCfgNode only | only = this.getKeywordArgument("only") |
        // only: :index
        result = only.getConstantValue().getStringlikeValue()
        or
        // only: [:index, :show]
        result = only.(ArrayLiteralCfgNode).getAnArgument().getConstantValue().getStringlikeValue()
      )
    }

    string getExceptArgument() {
      exists(ExprCfgNode except | except = this.getKeywordArgument("except") |
        // except: :create
        result = except.getConstantValue().getStringlikeValue()
        or
        // except: [:create, :update]
        result =
          except.(ArrayLiteralCfgNode).getAnArgument().getConstantValue().getStringlikeValue()
      )
    }

    /**
     * Gets an action which this filter is applied to.
     */
    Method getAction() {
      result = this.getEnclosingModule().getAMethod() and
      not result.isPrivate() and
      (
        result.getName() = this.getOnlyArgument()
        or
        not exists(this.getOnlyArgument()) and
        forall(string except | except = this.getExceptArgument() | result.getName() != except)
      )
    }
  }

  class BeforeFilter extends ActionControllerFilterConfigCall {
    BeforeFilter() { this.getMethodName() = ["before_action"] }
  }

  class AfterFilter extends ActionControllerFilterConfigCall {
    AfterFilter() { this.getMethodName() = ["after_action"] }
  }

  predicate additionalJumpStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Flow from a [post-update] self arg node to a self parameter node
    pred.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() instanceof SelfVariableAccessCfgNode and
    succ instanceof DataFlowPrivate::SelfParameterNode and
    // and the post-update node is from an instance var assignment
    DataFlowPrivate::storeStep(_, _, pred) and
    // and the post-update node is in a callback method
    // and the self parameter node is for an action method that the callback applies to
    exists(Method predMethod, Method succMethod |
      predMethod =
        pred.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr().getExpr().getEnclosingCallable() and
      succMethod = succ.(DataFlowPrivate::SelfParameterNode).getMethod()
    |
      exists(BeforeFilter call |
        call.getFilterCallable() = predMethod and call.getAction() = succMethod
      )
      or
      exists(AfterFilter call |
        call.getFilterCallable() = succMethod and call.getAction() = predMethod
      )
    )
  }
}
