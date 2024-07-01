/**
 * @name Missing origin verification in `postMessage` handler
 * @description Missing origin verification in a `postMessage` handler allows any windows to send arbitrary data to the handler.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5
 * @precision medium
 * @id js/missing-origin-check
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 *       external/cwe/cwe-940
 */

import javascript

/** A function that handles "message" events. */
class PostMessageHandler extends DataFlow::FunctionNode {
  override PostMessageEventHandler astNode;

  /** Gets the parameter that contains the event. */
  DataFlow::ParameterNode getEventParameter() {
    result = DataFlow::parameterNode(astNode.getEventParameter())
  }
}

/** Gets a reference to the event from a postmessage `handler` */
DataFlow::SourceNode event(DataFlow::TypeTracker t, PostMessageHandler handler) {
  t.start() and
  result = handler.getEventParameter()
  or
  exists(DataFlow::TypeTracker t2 | result = event(t2, handler).track(t2, t))
}

/** Gets a reference to the .origin from a postmessage event. */
DataFlow::SourceNode origin(DataFlow::TypeTracker t, PostMessageHandler handler) {
  t.start() and
  result = event(DataFlow::TypeTracker::end(), handler).getAPropertyRead("origin")
  or
  result =
    origin(t.continue(), handler)
        .getAMethodCall([
            "toString", "toLowerCase", "toUpperCase", "toLocaleLowerCase", "toLocaleUpperCase"
          ])
  or
  exists(DataFlow::TypeTracker t2 | result = origin(t2, handler).track(t2, t))
}

/** The only way to make secure postMessage `handler` is to check event.origin with strict equality operator or use whitelist */
predicate hasOriginCheck(PostMessageHandler handler) {
  // event.origin === "constant"
  exists(StrictEqualityTest test | origin(DataFlow::TypeTracker::end(), handler).flowsToExpr(test.getAnOperand()))
  or
  // set.includes(event.origin)
  exists(InclusionTest test | origin(DataFlow::TypeTracker::end(), handler).flowsTo(test.getContainedNode()))
}

from PostMessageHandler handler 
where not hasOriginCheck(handler)
select handler.getEventParameter(), "Postmessage handler has no origin check."
