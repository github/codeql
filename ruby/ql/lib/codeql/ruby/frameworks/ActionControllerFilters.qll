private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate

module ActionControllerFilters {
  /**
   * A call that registers a callback for one or more actions.
   * These are commonly called filters.
   */
  class Filter extends MethodCallCfgNode {
    private ActionControllerClass controller;
    private ModuleBase enclosingModule;

    Filter() {
      this.getExpr().getEnclosingModule() = enclosingModule and
      enclosingModule = controller.getADeclaration() and
      this.getMethodName() =
        ["", "prepend_", "append"] + ["before_action", "after_action", "around_action"]
    }

    /**
     * Holds if this callback is registered before `other`. This does not
     * guarantee that the callback will be executed before `other`. For example,
     * `after_action` callbacks are executed in reverse order.
     */
    predicate registeredBefore(Filter other) {
      this.getEnclosingModule() = other.getEnclosingModule() and
      (
        this.getLocation().getStartLine() < other.getLocation().getStartLine()
        or
        this.getLocation().getStartLine() = other.getLocation().getStartLine() and
        this.getLocation().getStartColumn() < other.getLocation().getStartColumn()
      )
    }

    /**
     * Holds if this callback runs before `other`.
     */
    predicate runsBefore(Filter other) { registeredBefore(other) }

    private string getFilterName() {
      result = this.getArgument(0).getConstantValue().getStringlikeValue()
    }

    private ModuleBase getEnclosingModule() { result = enclosingModule }

    /**
     * Gets the callable that implements this filter.
     * This currently only finds methods in the local class or superclass.
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
    ActionControllerActionMethod getAction() {
      // A filter cannot apply to another filter
      result != any(Filter f).getFilterCallable() and
      // Only include routable actions. This can exclude valid actions if we can't parse the `routes.rb` file fully.
      exists(result.getARoute()) and
      result = this.getEnclosingModule().getAMethod() and
      (
        result.getName() = this.getOnlyArgument()
        or
        not exists(this.getOnlyArgument()) and
        forall(string except | except = this.getExceptArgument() | result.getName() != except)
      )
    }

    Filter getNextFilter() { none() }
  }

  class BeforeFilter extends Filter {
    BeforeFilter() { this.getMethodName() = "before_action" }

    override BeforeFilter getNextFilter() {
      result != this and
      this.runsBefore(result) and
      not exists(BeforeFilter mid | this.runsBefore(mid) | mid.runsBefore(result))
    }
  }

  class AfterFilter extends Filter {
    AfterFilter() { this.getMethodName() = "after_action" }

    override predicate runsBefore(Filter other) { other.registeredBefore(this) }

    override AfterFilter getNextFilter() {
      result != this and
      this.runsBefore(result) and
      not exists(AfterFilter mid | this.runsBefore(mid) and mid.runsBefore(result))
    }
  }

  /**
   * Holds if `pred` is called before `succ` in the callback chain.
   * `pred` and `succ` may be methods bound to callbacks or controller actions.
   */
  predicate next(Method pred, Method succ) {
    exists(BeforeFilter f | pred = f.getFilterCallable() |
      succ = f.getNextFilter().getFilterCallable()
      or
      not exists(f.getNextFilter()) and succ = f.getAction()
    )
    or
    exists(AfterFilter f |
      pred = f.getAction() and
      succ = f.getFilterCallable() and
      not exists(AfterFilter g | g.getNextFilter() = f)
      or
      pred = f.getFilterCallable() and succ = f.getNextFilter().getFilterCallable()
    )
  }

  pragma[inline]
  predicate variableAccessPostUpdate(DataFlow::PostUpdateNode n, Method m) {
    n.getPreUpdateNode().asExpr() instanceof SelfVariableAccessCfgNode and
    m = n.getPreUpdateNode().asExpr().getExpr().getEnclosingCallable() and
    DataFlowPrivate::storeStep(_, _, n)
  }

  pragma[inline]
  predicate selfParameter(DataFlowPrivate::SelfParameterNode n, Method m) { m = n.getMethod() }

  predicate additionalJumpStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Method predMethod, Method succMethod |
      variableAccessPostUpdate(pred, predMethod) and
      selfParameter(succ, succMethod) and
      next(predMethod, succMethod)
    )
  }
}
