/**
 * @name Potentially inconsistent state update
 * @description Updating the state of a component based on the current value of
 *              'this.state' or 'this.props' may lead to inconsistent component
 *              state.
 * @kind problem
 * @problem.severity warning
 * @id js/react/inconsistent-state-update
 * @tags reliability
 *       frameworks/react
 * @precision very-high
 */

import semmle.javascript.frameworks.React

/**
 * Gets an unsafe property access, that is, an expression that reads (a property of)
 * `this.state` or `this.prop` on component `c`.
 */
DataFlow::PropRead getAnUnsafeAccess(ReactComponent c) {
  result = c.getAPropRead() or
  result = c.getAStateAccess()
}

/**
 * Gets at unsafe property access that is not the base of another unsafe property
 * access.
 */
DataFlow::PropRead getAnOutermostUnsafeAccess(ReactComponent c) {
  result = getAnUnsafeAccess(c) and
  not exists(DataFlow::PropRead outer | outer = getAnUnsafeAccess(c) | result = outer.getBase())
}

/**
 * Gets a property write through `setState` for state property `name` of `c`.
 */
DataFlow::PropWrite getAStateUpdate(ReactComponent c, string name) {
  exists(DataFlow::ObjectLiteralNode newState |
    newState.flowsTo(c.getAMethodCall("setState").getArgument(0)) and
    result = newState.getAPropertyWrite(name)
  )
}

/**
 * Gets a property write through `setState` for a state property of `c` that is only written at this property write.
 */
DataFlow::PropWrite getAUniqueStateUpdate(ReactComponent c) {
  exists(string name |
    count(getAStateUpdate(c, name)) = 1 and
    result = getAStateUpdate(c, name)
  )
}

/**
 * Holds for "self dependent" component state updates. E.g. `this.setState({toggled: !this.state.toggled})`.
 */
predicate isAStateUpdateFromSelf(ReactComponent c, DataFlow::PropWrite pwn, DataFlow::PropRead prn) {
  exists(string name |
    pwn = getAStateUpdate(c, name) and
    c.getADirectStateAccess().flowsTo(prn.getBase()) and
    prn.getPropertyName() = name and
    pwn.getRhs().asExpr() = prn.asExpr().getParentExpr*() and
    pwn.getContainer() = prn.getContainer()
  )
}

from ReactComponent c, MethodCallExpr setState, Expr getState
where
  setState = c.getAMethodCall("setState").asExpr() and
  getState = getAnOutermostUnsafeAccess(c).asExpr() and
  getState.getParentExpr*() = setState.getArgument(0) and
  getState.getEnclosingFunction() = setState.getEnclosingFunction() and
  // ignore self-updates that only occur in one location: `setState({toggled: !this.state.toggled})`, they are most likely safe in practice
  not exists(DataFlow::PropWrite pwn |
    pwn = getAUniqueStateUpdate(c) and
    isAStateUpdateFromSelf(c, pwn, DataFlow::valueNode(getState))
  )
select setState, "Component state update uses $@.", getState, "potentially inconsistent value"
