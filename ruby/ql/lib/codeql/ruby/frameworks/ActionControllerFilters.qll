private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * Provides modelling for ActionController filters.
 */
module ActionControllerFilters {
  /**
   * A call that registers a callback for one or more ActionController actions.
   * These are commonly called filters.
   *
   * In the example below, the `before_action` call registers `set_user` as a
   * callback for all actions in the controller. When a request is routed to
   * `PostsController#index`, the method `set_user` will be called before
   * `index` is executed.
   *
   * The `after_action` call registers `log_request` as a callback. This behaves
   * similarly to `before_action` but the callback will be called _after_ the
   * action has finished executing.
   *
   * The `around_action` call registers `trace_request` as a callback that will
   * run _around_ the action. This means that `trace_request` will be called
   * before the action, and will run until it `yield`s control. Then the action
   * (or another callback) will be run. Once the action has run, control will be
   * returned to `trace_request`, which will finish executing.
   *
   * Due to the complexity of dataflow around `yield` calls, currently only
   * `before_action` and `after_action` callbacks are modelled fully here.
   *
   * ```rb
   * class PostsController < ApplicationController
   *   before_action :set_user
   *   after_action :log_request
   *   around_action :trace_request
   *
   *   def index
   *     @posts = @user.posts.all
   *   end
   *
   *   private
   *
   *   def set_user
   *     @user = User.find(session[:user_id])
   *   end
   *
   *   def log_request
   *     Logger.info(request.path)
   *   end
   *
   *   def trace_request
   *     start = Time.now
   *     yield
   *     Logger.info("Request took #{Time.now = start} seconds")
   *   end
   * end
   * ```
   */
  private class Filter extends StringlikeLiteralCfgNode {
    private MethodCallCfgNode call;

    Filter() {
      call.getExpr().getEnclosingModule() = any(ActionControllerClass c).getADeclaration() and
      call.getMethodName() =
        ["", "prepend_", "append_", "skip_"] + ["before_action", "after_action", "around_action"] and
      this = call.getPositionalArgument(_)
    }

    MethodCallCfgNode getCall() { result = call }

    private ModuleBase getEnclosingModule() { result = call.getExpr().getEnclosingModule() }

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
      or
      // This callback is in a superclass of `other`'s class.
      other.getEnclosingModule().getModule() = this.getEnclosingModule().getModule().getASubClass+()
    }

    /**
     * Holds if this callback runs before `other`.
     */
    predicate runsBefore(Filter other, ActionControllerActionMethod action) {
      this.registeredBefore(other) and action = this.getAction() and action = other.getAction()
    }

    private string getFilterName() { result = this.getConstantValue().getStringlikeValue() }

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
      exists(ExprCfgNode only | only = call.getKeywordArgument("only") |
        // only: :index
        result = only.getConstantValue().getStringlikeValue()
        or
        // only: [:index, :show]
        result = only.(ArrayLiteralCfgNode).getAnArgument().getConstantValue().getStringlikeValue()
      )
    }

    string getExceptArgument() {
      exists(ExprCfgNode except | except = call.getKeywordArgument("except") |
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
      (
        result.getName() = this.getOnlyArgument()
        or
        not exists(this.getOnlyArgument()) and
        forall(string except | except = this.getExceptArgument() | result.getName() != except)
      ) and
      (
        result = this.getEnclosingModule().getAMethod()
        or
        exists(ModuleBase m |
          m.getModule() = this.getEnclosingModule().getModule().getADescendent() and
          result = m.getAMethod()
        )
      )
    }

    Filter getNextFilter(ActionControllerActionMethod action) { none() }
  }

  private class BeforeFilter extends Filter {
    BeforeFilter() { this.getCall().getMethodName() = "before_action" }

    override BeforeFilter getNextFilter(ActionControllerActionMethod action) {
      result != this and
      this.runsBefore(result, action) and
      not exists(BeforeFilter mid | this.runsBefore(mid, action) | mid.runsBefore(result, action))
    }

    override predicate runsBefore(Filter other, ActionControllerActionMethod action) {
      other instanceof BeforeFilter and
      super.runsBefore(other, action) and
      not this.skipped(_, _, action) and
      not other.(BeforeFilter).skipped(_, _, action)
    }

    predicate skipped(SkipBeforeFilter f, Callable c, ActionControllerActionMethod m) {
      c = this.getFilterCallable() and
      m = this.getAction() and
      c = f.getFilterCallable() and
      m = f.getAction()
    }
  }

  private class SkipBeforeFilter extends Filter {
    SkipBeforeFilter() { this.getCall().getMethodName() = "skip_before_action" }
  }

  private class AfterFilter extends Filter {
    AfterFilter() { this.getCall().getMethodName() = "after_action" }

    override predicate runsBefore(Filter other, ActionControllerActionMethod action) {
      action = this.getAction() and
      action = other.getAction() and
      other.(AfterFilter).registeredBefore(this) and
      not this.skipped(_, _, action) and
      not other.(AfterFilter).skipped(_, _, action)
    }

    predicate skipped(SkipAfterFilter f, Callable c, ActionControllerActionMethod m) {
      c = this.getFilterCallable() and
      m = this.getAction() and
      c = f.getFilterCallable() and
      m = f.getAction()
    }

    override AfterFilter getNextFilter(ActionControllerActionMethod action) {
      result != this and
      this.runsBefore(result, action) and
      not exists(AfterFilter mid | this.runsBefore(mid, action) and mid.runsBefore(result, action))
    }
  }

  private class SkipAfterFilter extends Filter {
    SkipAfterFilter() { this.getCall().getMethodName() = "skip_after_action" }
  }

  /**
   * Holds if `pred` is called before `succ` in the callback chain for action `action`.
   * `pred` and `succ` may be methods bound to callbacks or controller actions.
   */
  private predicate next(Method pred, Method succ, ActionControllerActionMethod action) {
    exists(BeforeFilter f | pred = f.getFilterCallable() |
      // Non-terminal before filter
      succ = f.getNextFilter(action).getFilterCallable()
      or
      // Final before filter
      not exists(f.getNextFilter(action)) and
      not f.skipped(_, _, action) and
      action = f.getAction() and
      succ = action
    )
    or
    exists(AfterFilter f |
      // First after filter
      action = f.getAction() and
      pred = action and
      succ = f.getFilterCallable() and
      not exists(AfterFilter g | g.getNextFilter(action) = f)
      or
      // Subsequent after filter
      pred = f.getFilterCallable() and
      succ = f.getNextFilter(action).getFilterCallable()
    )
  }

  pragma[inline]
  private predicate variableAccessPostUpdate(DataFlow::PostUpdateNode n, Method m) {
    n.getPreUpdateNode().asExpr() instanceof SelfVariableAccessCfgNode and
    m = n.getPreUpdateNode().asExpr().getExpr().getEnclosingCallable() and
    DataFlowPrivate::storeStep(_, _, n)
  }

  pragma[inline]
  private predicate selfParameter(DataFlowPrivate::SelfParameterNode n, Method m) {
    m = n.getMethod()
  }

  /**
   * Holds if data can flow from `pred` to `succ` via a callback chain.
   * `pred` is the post-update node of the self parameter in a method, and
   * `succ` is the self parameter of a subsequent method that is executed as
   * part of the callback chain.
   */
  predicate additionalJumpStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Method predMethod, Method succMethod |
      variableAccessPostUpdate(pred, predMethod) and
      selfParameter(succ, succMethod) and
      next(predMethod, succMethod, _)
    )
  }
}
