/**
 * @name Unsupported state update in lifecycle method
 * @description Attempting to update the state of a React component at the wrong time can cause undesired behavior.
 * @kind problem
 * @problem.severity warning
 * @id js/react/unsupported-state-update-in-lifecycle-method
 * @tags reliability
 *       frameworks/react
 * @precision high
 */

import javascript

/**
 * A call that invokes a method on its own receiver.
 */
class CallOnSelf extends DataFlow::CallNode {
  CallOnSelf() {
    exists(Function binder | binder = this.getEnclosingFunction().getThisBinder() |
      exists(DataFlow::ThisNode thiz |
        this = thiz.getAMethodCall(_) and
        thiz.getBinder().getAstNode() = binder
      )
      or
      this.getACallee().(ArrowFunctionExpr).getThisBinder() = binder
    )
  }

  /**
   * Gets a `CallOnSelf` in the callee of this call.
   */
  CallOnSelf getACalleCallOnSelf() { result.getEnclosingFunction() = this.getACallee() }
}

/**
 * A call that is definitely invoked by the caller, unless an exception occurs.
 */
class UnconditionalCallOnSelf extends CallOnSelf {
  UnconditionalCallOnSelf() { isUnconditionalCall(this) }

  override UnconditionalCallOnSelf getACalleCallOnSelf() {
    result = CallOnSelf.super.getACalleCallOnSelf()
  }
}

/**
 * Holds if `call` is guaranteed to occur in its enclosing function, unless an exception occurs.
 */
predicate isUnconditionalCall(DataFlow::CallNode call) {
  exists(ReachableBasicBlock callBlock, ReachableBasicBlock entryBlock |
    callBlock.postDominates(entryBlock) and
    callBlock = call.getBasicBlock() and
    entryBlock = call.getEnclosingFunction().getEntryBB()
  )
}

predicate isStateUpdateMethodCall(DataFlow::MethodCallNode mce) {
  exists(string updateMethodName |
    updateMethodName = "setState" or
    updateMethodName = "replaceState" or
    updateMethodName = "forceUpdate"
  |
    mce.getMethodName() = updateMethodName
  )
}

/**
 * A React component method in which state updates may have surprising effects.
 */
class StateUpdateVolatileMethod extends Function {
  string methodName;

  StateUpdateVolatileMethod() {
    // methods that are known to be ok:
    // - componentWillUnmount
    // - componentsWillMount
    // - componentsDidMount
    exists(ReactComponent c |
      methodName =
        [
          "componentDidUnmount", "componentDidUpdate", "componentWillUpdate", "getDefaultProps",
          "getInitialState", "render", "shouldComponentUpdate"
        ]
    |
      this = c.getInstanceMethod(methodName)
    )
    or
    this = any(ES2015Component c).getConstructor().getBody() and
    methodName = "constructor"
  }

  /**
   * Holds if conditional state updates are benign in this method.
   */
  predicate conditionalStateUpatesAreBenign() {
    methodName = "componentDidUpdate" or
    methodName = "componentWillUpdate" or
    methodName = "shouldComponentUpdate"
  }
}

from
  StateUpdateVolatileMethod root, CallOnSelf initCall, DataFlow::MethodCallNode stateUpdate,
  string callDescription
where
  initCall.getEnclosingFunction() = root and
  stateUpdate = initCall.getACalleCallOnSelf*() and
  isStateUpdateMethodCall(stateUpdate) and
  if root.conditionalStateUpatesAreBenign()
  then
    initCall instanceof UnconditionalCallOnSelf and
    callDescription = "Unconditional call"
  else callDescription = "Call"
select initCall,
  callDescription + " to state update method $@ is not allowed from within this method.",
  stateUpdate, " ." + stateUpdate.getMethodName()
