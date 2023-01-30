/**
 * Provides modeling for ActionController filters.
 */

private import codeql.ruby.AST
private import codeql.ruby.frameworks.ActionController
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.ruby.ast.internal.Constant

/**
 * Provides modeling for ActionController filters.
 */
module Filters {
  private newtype TFilterKind =
    TBeforeKind() or
    TAfterKind() or
    TAroundKind()

  /**
   * Represents the kind of filter.
   * "before" filters run before the action and "after" filters run after the
   * action. "around" filters run around the action, `yield`ing to it at will.
   */
  private class FilterKind extends TFilterKind {
    string toString() {
      this = TBeforeKind() and result = "before"
      or
      this = TAfterKind() and result = "after"
      or
      this = TAroundKind() and result = "around"
    }
  }

  /**
   * A call to a class method that adds or removes a filter from the callback chain.
   * This class exists to encapsulate common behavior between calls that
   * register callbacks (`before_action`, `after_action` etc.) and calls that
   * remove callbacks (`skip_before_action`, `skip_after_action` etc.)
   */
  private class FilterCall extends MethodCallCfgNode {
    private FilterKind kind;

    FilterCall() {
      this.getExpr().getEnclosingModule() = any(ActionControllerClass c).getADeclaration() and
      this.getMethodName() = ["", "prepend_", "append_", "skip_"] + kind + "_action"
    }

    FilterKind getKind() { result = kind }

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
        result = this.getExpr().getEnclosingModule().getAMethod()
        or
        exists(ModuleBase m |
          m.getModule() = this.getExpr().getEnclosingModule().getModule().getADescendent() and
          result = m.getAMethod()
        )
      )
    }

    private string getOnlyArgument() {
      exists(ExprCfgNode only | only = this.getKeywordArgument("only") |
        // only: :index
        result = only.getConstantValue().getStringlikeValue()
        or
        // only: [:index, :show]
        // only: SOME_CONST_ARRAY
        exists(ArrayLiteralCfgNode n |
          isArrayConstant(only, n) and
          result = n.getAnArgument().getConstantValue().getStringlikeValue()
        )
      )
    }

    private string getExceptArgument() {
      exists(ExprCfgNode except | except = this.getKeywordArgument("except") |
        // except: :create
        result = except.getConstantValue().getStringlikeValue()
        or
        // except: [:create, :update]
        result =
          except.(ArrayLiteralCfgNode).getAnArgument().getConstantValue().getStringlikeValue()
      )
    }

    StringlikeLiteralCfgNode getFilterArgument() { result = this.getPositionalArgument(_) }

    /**
     * Gets the callable that implements the filter with name `name`.
     * This currently only finds methods in the local class or superclass.
     * It doesn't handle:
     * - lambdas
     * - blocks
     * - classes
     *
     * In the example below, the callable for the filter `:foo` is the method `foo`.
     * ```rb
     * class PostsController < ActionController::Base
     *   before_action :foo
     *
     *   def foo
     *   end
     * end
     * ```
     */
    Callable getFilterCallable(string name) {
      result.(MethodBase).getName() = name and
      // Method in same class
      (
        result.getEnclosingModule() = this.getExpr().getEnclosingModule()
        or
        // Method in superclass
        result.getEnclosingModule().getModule() =
          this.getExpr().getEnclosingModule().getModule().getSuperClass()
      )
    }
  }

  /**
   * An argument to a call that registers a callback for one or more
   * ActionController actions. These are commonly called filters.
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
   * `before_action` and `after_action` callbacks are modeled fully here.
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
    private FilterCall call;
    private FilterKind kind;

    Filter() {
      this = call.getFilterArgument() and
      kind = call.getKind() and
      call.getMethodName() = ["", "prepend_", "append_"] + kind + "_action"
    }

    predicate isPrepended() { call.getMethodName().regexpMatch("^prepend.+$") }

    MethodCallCfgNode getCall() { result = call }

    FilterKind getKind() { result = kind }

    /**
     * Holds if this callback is registered before `other`. This does not
     * guarantee that the callback will be executed before `other`. For example,
     * `after_action` callbacks are executed in reverse order.
     */
    predicate registeredBefore(Filter other) { callbackRegisteredBefore(call, _, this, other) }

    /**
     * Holds if this callback runs before `other`.
     */
    private predicate runsBefore(Filter other, ActionControllerActionMethod action) {
      other.getKind() = this.getKind() and
      not this.skipped(action) and
      not other.skipped(action) and
      action = this.getAction() and
      action = other.getAction() and
      (
        not this.isPrepended() and
        (
          not other.isPrepended() and
          (
            this.getKind() = TBeforeKind() and
            this.registeredBefore(other)
            or
            this.getKind() = TAfterKind() and
            other.registeredBefore(this)
          )
          or
          other.isPrepended() and this.getKind() = TAfterKind()
        )
        or
        this.isPrepended() and
        (
          not other.isPrepended() and
          this.getKind() = TBeforeKind()
          or
          other.isPrepended() and
          (
            this.getKind() = TBeforeKind() and this.registeredBefore(other)
            or
            this.getKind() = TAfterKind() and other.registeredBefore(this)
          )
        )
      )
    }

    Filter getNextFilter(ActionControllerActionMethod action) {
      result != this and
      this.runsBefore(result, action) and
      not exists(Filter mid | this.runsBefore(mid, action) | mid.runsBefore(result, action))
    }

    /**
     * Holds if this callback does not run for `action`. This is either because
     * it has been explicitly skipped by a `SkipFilter` or because a callback
     * with the same name is registered later one, overriding this one.
     */
    predicate skipped(ActionControllerActionMethod action) {
      this =
        any(SkipFilter f | f.getKind() = this.getKind() and this.registeredBefore(f))
            .getSkippedFilter(action) or
      this.overridden()
    }

    /**
     * Holds if this callback is overridden by a callback with the same name. For example:
     * ```rb
     * class UsersController
     *   before_action :foo # this filter is override by the subsequent `before_action :foo` call below.
     *   before_action :bar
     *   before_action :foo
     * end
     * ```
     */
    private predicate overridden() {
      exists(Filter f |
        f != this and
        f.getFilterCallable() = this.getFilterCallable() and
        f.getFilterName() = this.getFilterName() and
        f.getKind() = this.getKind() and
        this.registeredBefore(f)
      )
    }

    private string getFilterName() { result = this.getConstantValue().getStringlikeValue() }

    Callable getFilterCallable() { result = call.getFilterCallable(this.getFilterName()) }

    ActionControllerActionMethod getAction() { result = call.getAction() }
  }

  private class BeforeFilter extends Filter {
    BeforeFilter() { this.getKind() = TBeforeKind() }
  }

  private class AfterFilter extends Filter {
    AfterFilter() { this.getKind() = TAfterKind() }
  }

  /**
   * A call to `skip_before_action`, `skip_after_action` or `skip_around_action`.
   * This skips a previously registered callback.
   * Like other filter calls, the `except` and `only` keyword arguments can be
   * passed to restrict the actions that the callback is skipped for.
   */
  private class SkipFilter extends StringlikeLiteralCfgNode {
    private FilterCall call;
    private FilterKind kind;

    SkipFilter() {
      this = call.getFilterArgument() and
      call.getMethodName() = "skip_" + kind + "_action"
    }

    FilterKind getKind() { result = kind }

    private string getFilterName() { result = this.getConstantValue().getStringlikeValue() }

    Callable getFilterCallable() { result = call.getFilterCallable(this.getFilterName()) }

    ActionControllerActionMethod getAction() { result = call.getAction() }

    predicate registeredBefore(StringlikeLiteralCfgNode other) {
      (other instanceof SkipFilter or other instanceof Filter) and
      callbackRegisteredBefore(call, _, this, other)
    }

    Filter getSkippedFilter(ActionControllerActionMethod action) {
      not result instanceof SkipFilter and
      action = this.getAction() and
      action = result.getAction() and
      result.getFilterCallable() = this.getFilterCallable()
    }
  }

  /**
   * Holds if `predCall` (resp. `succCall`) registers or skips the callback referred to by `pred` (`succ`) and `predCall` is evaluated called before `succCall`.
   * Typically this means that `pred` is registered before `succ`, or `pred` is skipped before `succ`, depending on the nature of the call.
   * `pred` and `succ` are expected to be arguments. In the examples below, `pred` is `:foo` and `succ` is `:bar`.
   * ```rb
   * before_action :foo, :bar
   * skip_before_action :foo, :bar
   * ```
   * This does not guarantee that the callback referred to by `pred` will be executed before
   * `succ`. For example, `after_action` callbacks are executed in reverse order.
   */
  private predicate callbackRegisteredBefore(
    FilterCall predCall, FilterCall succCall, StringlikeLiteralCfgNode pred,
    StringlikeLiteralCfgNode succ
  ) {
    pred = predCall.getFilterArgument() and
    succ = succCall.getFilterArgument() and
    (
      // before_action :this, :other
      //
      // before_action :this
      // before_action :other
      pred.getBasicBlock() = succ.getBasicBlock() and
      pred.getASuccessor+() = succ
      or
      predCall.getExpr().getEnclosingModule() = succCall.getExpr().getEnclosingModule() and
      pred.getBasicBlock().strictlyDominates(succ.getBasicBlock()) and
      pred != succ
      or
      // This callback is in a superclass of `other`'s class.
      //
      // class A
      //   before_action :this
      //
      // class B < A
      //   before_action :other
      succCall.getExpr().getEnclosingModule().getModule() =
        predCall.getExpr().getEnclosingModule().getModule().getASubClass+()
    )
  }

  /**
   * Holds if `pred` is called before `succ` in the callback chain for action `action`.
   * `pred` and `succ` may be methods bound to callbacks or controller actions.
   */
  predicate next(ActionControllerActionMethod action, Method pred, Method succ) {
    exists(BeforeFilter f | pred = f.getFilterCallable() |
      // Non-terminal before filter
      succ = f.getNextFilter(action).getFilterCallable()
      or
      // Final before filter
      not exists(f.getNextFilter(action)) and
      not f.skipped(action) and
      action = f.getAction() and
      succ = action
    )
    or
    exists(AfterFilter f |
      // First after filter
      action = f.getAction() and
      not f.skipped(action) and
      pred = action and
      succ = f.getFilterCallable() and
      not exists(AfterFilter g | g.getNextFilter(action) = f)
      or
      // Subsequent after filter
      pred = f.getFilterCallable() and
      succ = f.getNextFilter(action).getFilterCallable()
    )
  }

  /**
   * Holds if `pred` is called before `succ` in the callback chain for some action.
   * `pred` and `succ` may be methods bound to callbacks or controller actions.
   */
  predicate next(Method pred, Method succ) { next(_, pred, succ) }
}
