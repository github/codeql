/**
 * @name Unused or undefined state property
 * @description Unused or undefined component state properties may be a symptom of a bug and should be examined carefully.
 * @kind problem
 * @problem.severity warning
 * @id js/react/unused-or-undefined-state-property
 * @tags correctness
 *       reliability
 *       frameworks/react
 * @precision high
 */

import semmle.javascript.frameworks.React
import semmle.javascript.RestrictedLocations

/**
 * Gets the source of a future, present or past state object of `c`.
 */
DataFlow::SourceNode potentialStateSource(ReactComponent c) {
  result = c.getACandidateStateSource() or
  result = c.getADirectStateAccess() or
  result = c.getAPreviousStateSource()
}

/**
 * Gets an access to a state property of `c`, both future, present or past state objects are considered.
 */
DataFlow::PropRef getAPotentialStateAccess(ReactComponent c) {
  potentialStateSource(c).flowsTo(result.getBase())
}

/**
 * Holds if the state object of `c` escapes from the scope of this file's query.
 */
predicate hasAStateEscape(ReactComponent c) {
  exists(DataFlow::InvokeNode invk |
    not invk = c.getAMethodCall("setState") and
    potentialStateSource(c).flowsTo(invk.getAnArgument())
  )
}

/**
 * Holds if there exists a write for a state property of `c` that uses an unknown property name.
 */
predicate hasUnknownStatePropertyWrite(ReactComponent c) {
  exists(DataFlow::PropWrite pwn |
    pwn = getAPotentialStateAccess(c) and
    not exists(pwn.getPropertyName())
  )
  or
  exists(DataFlow::SourceNode source |
    source = c.getACandidateStateSource() and
    not source instanceof DataFlow::ObjectLiteralNode
  )
}

/**
 * Holds if there exists a read for a state property of `c` that uses an unknown property name.
 */
predicate hasUnknownStatePropertyRead(ReactComponent c) {
  exists(DataFlow::PropRead prn |
    prn = getAPotentialStateAccess(c) and
    not exists(prn.getPropertyName())
  )
  or
  exists(SpreadElement spread | potentialStateSource(c).flowsToExpr(spread.getOperand()))
}

/**
 * Holds if `c` uses the `mixins` mechanism (an obsolete React feature) .
 */
predicate usesMixins(ES5Component c) {
  c.flow().(DataFlow::SourceNode).hasPropertyWrite("mixins", _)
}

/**
 * Gets a write for a state property of `c` that has no corresponding read.
 */
DataFlow::PropWrite getAnUnusedStateProperty(ReactComponent c) {
  result = getAPotentialStateAccess(c) and
  exists(string name | name = result.getPropertyName() |
    not exists(DataFlow::PropRead prn |
      prn = getAPotentialStateAccess(c) and
      prn.getPropertyName() = name
    )
  )
}

/**
 * Gets a read for a state property of `c` that has no corresponding write.
 */
DataFlow::PropRead getAnUndefinedStateProperty(ReactComponent c) {
  result = getAPotentialStateAccess(c) and
  exists(string name | name = result.getPropertyName() |
    not exists(DataFlow::PropWrite pwn |
      pwn = getAPotentialStateAccess(c) and
      pwn.getPropertyName() = name
    )
  )
}

from ReactComponent c, DataFlow::PropRef n, string action, string nonAction
where
  (
    action = "written" and
    nonAction = "read" and
    n = getAnUnusedStateProperty(c) and
    not hasUnknownStatePropertyRead(c)
    or
    action = "read" and
    nonAction = "written" and
    n = getAnUndefinedStateProperty(c) and
    not hasUnknownStatePropertyWrite(c)
  ) and
  not hasAStateEscape(c) and
  not usesMixins(c)
select c.(FirstLineOf),
  "Component state property '" + n.getPropertyName() + "' is $@, but it is never " + nonAction + ".",
  n, action
