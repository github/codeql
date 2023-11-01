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
private import codeql.ruby.ast.internal.Module

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

  bindingset[call]
  pragma[inline_late]
  private ActionControllerActionMethod getADescendentAction(MethodCallCfgNode call) {
    result = call.getExpr().getEnclosingModule().getAMethod()
    or
    exists(ModuleBase m |
      m.getModule() = call.getExpr().getEnclosingModule().getModule().getAnImmediateDescendent+() and
      result = m.getAMethod()
    )
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
    ActionControllerActionMethod getAnAction() {
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
      result = getADescendentAction(this)
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
        // except: SOME_CONST_ARRAY
        exists(ArrayLiteralCfgNode n |
          isArrayConstant(except, n) and
          result = n.getAnArgument().getConstantValue().getStringlikeValue()
        )
      )
    }

    StringlikeLiteralCfgNode getFilterArgument() { result = this.getPositionalArgument(_) }

    string getFilterArgumentName() {
      result = this.getFilterArgument().getConstantValue().getStringlikeValue()
    }

    /**
     * Gets the callable that implements a filter registered by this call.
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
    Callable getAFilterCallable() {
      result =
        lookupMethod(this.getExpr().getEnclosingModule().getModule(), this.getFilterArgumentName())
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
   *     Logger.info("Request took #{Time.now - start} seconds")
   *   end
   * end
   * ```
   */
  private class Filter extends FilterImpl {
    Filter() { not this.isSkipFilter() }

    /**
     * Holds if this callback does not run for `action`. This is either because
     * it has been explicitly skipped by a `SkipFilter` or because a callback
     * with the same name is registered later one, overriding this one.
     */
    predicate skipped(ActionControllerActionMethod action) {
      action = this.getAnAction() and
      (
        this = any(SkipFilter f).getSkippedFilter(action) or
        this.overridden()
      )
    }

    /**
     * Holds if this callback runs before `other`.
     */
    predicate runsBefore(Filter other, ActionControllerActionMethod action) {
      other.getKind() = this.getKind() and
      not this.skipped(action) and
      not other.skipped(action) and
      action = this.getAnAction() and
      action = other.getAnAction() and
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
  }

  /**
   * Behavior that is common to filters and `skip_*` calls.
   * This is separated just because when we don't want `Filter` to include `skip_*` calls.
   */
  private class FilterImpl extends StringlikeLiteralCfgNode {
    private FilterCall call;
    private FilterKind kind;

    FilterImpl() {
      this = call.getFilterArgument() and
      kind = call.getKind() and
      call.getMethodName() = ["", "prepend_", "append_", "skip_"] + kind + "_action"
    }

    predicate isSkipFilter() { call.getMethodName().regexpMatch("^skip_.+$") }

    predicate isPrepended() { call.getMethodName().regexpMatch("^prepend.+$") }

    FilterCall getCall() { result = call }

    FilterKind getKind() { result = kind }

    /**
     * Holds if this callback is registered before `other`. This does not
     * guarantee that the callback will be executed before `other`. For example,
     * `after_action` callbacks are executed in reverse order.
     */
    predicate registeredBefore(FilterImpl other) {
      exists(FilterCall otherCall |
        // predCall -> call
        // pred -> this
        // succ -> other
        other = otherCall.getFilterArgument() and
        (
          // before_action :this, :other
          //
          // before_action :this
          // before_action :other
          this.getBasicBlock() = other.getBasicBlock() and
          this.getASuccessor+() = other
          or
          call.getExpr().getEnclosingModule() = otherCall.getExpr().getEnclosingModule() and
          this.getBasicBlock().strictlyDominates(other.getBasicBlock()) and
          this != other
          or
          // This callback is in a superclass of `other`'s class.
          //
          // class A
          //   before_action :this
          //
          // class B < A
          //   before_action :other
          otherCall.getExpr().getEnclosingModule().getModule() =
            call.getExpr().getEnclosingModule().getModule().getASubClass+()
        )
      )
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
    predicate overridden() {
      exists(FilterImpl f |
        f != this and
        f.getFilterCallable() = this.getFilterCallable() and
        f.getFilterName() = this.getFilterName() and
        f.getKind() = this.getKind() and
        this.registeredBefore(f)
      )
    }

    string getFilterName() { result = this.getConstantValue().getStringlikeValue() }

    Callable getFilterCallable() {
      result = call.getAFilterCallable() and result.(MethodBase).getName() = this.getFilterName()
    }

    ActionControllerActionMethod getAnAction() { result = call.getAnAction() }
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
  private class SkipFilter extends FilterImpl {
    SkipFilter() { this.isSkipFilter() }

    Filter getSkippedFilter(ActionControllerActionMethod action) {
      action = this.getAnAction() and
      action = result.getAnAction() and
      result.getKind() = this.getKind() and
      result.registeredBefore(this) and
      result.getFilterCallable() = this.getFilterCallable()
    }
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
      action = f.getAnAction() and
      succ = action
    )
    or
    exists(AfterFilter f |
      // First after filter
      action = f.getAnAction() and
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

  /**
   * Holds if `n` is a post-update node for `self` in method `m`.
   */
  private predicate selfPostUpdate(DataFlow::PostUpdateNode n, Method m) {
    n.getPreUpdateNode().asExpr().getExpr() =
      any(SelfVariableAccess self |
        pragma[only_bind_into](m) = self.getEnclosingCallable() and
        self.getVariable().getDeclaringScope() = m
      )
  }

  /**
   * Holds if `n` is the self parameter of method `m`.
   */
  private predicate selfParameter(DataFlow::SelfParameterNode n, Method m) { m = n.getCallable() }

  /**
   * A class defining additional jump steps arising from filters.
   */
  class FilterJumpStep extends DataFlowPrivate::AdditionalJumpStep {
    /**
     * Holds if data can flow from `pred` to `succ` via a callback chain.
     * `pred` is the post-update node of the self parameter in a method, and
     * `succ` is the self parameter of a subsequent method that is executed as
     * part of the callback chain.
     */
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Method predMethod, Method succMethod | next(predMethod, succMethod) |
        // Flow from a post-update node of self  in `pred` to the self parameter of `succ`
        //
        // def a
        //   foo() ---------+
        //   @x = 1 ---+    |
        // end         |    |
        //             |    |
        // def b  <----+----+
        //  ...
        //
        selfPostUpdate(pred, predMethod) and
        selfParameter(succ, succMethod)
        or
        // Flow from the self parameter of `pred` to the self parameter of `succ`
        //
        // def a ---+
        //   ...    |
        // end      |
        //          |
        // def b  <-+
        //   ...
        //
        selfParameter(pred, predMethod) and
        selfParameter(succ, succMethod)
      )
    }
  }
}
