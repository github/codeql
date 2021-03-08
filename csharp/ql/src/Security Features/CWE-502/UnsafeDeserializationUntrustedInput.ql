/**
 * @name Deserialization of untrusted data
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind path-problem
 * @id cs/unsafe-deserialization-untrusted-input
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.UnsafeDeserialization::UnsafeDeserialization
import DataFlow::PathGraph
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.security.dataflow.flowsources.Local

class RemoteSource extends Source {
  RemoteSource() { this instanceof RemoteFlowSource }
}

class LocalSource extends Source {
  LocalSource() { this instanceof LocalFlowSource }
}

from
  TaintToObjectMethodTrackingConfig taintTracking, DataFlow::PathNode userInput,
  DataFlow::PathNode deserializeCall, TaintToObjectTypeTrackingConfig userControlledTypeTracking,
  DataFlow::PathNode userInput2, WeakTypeCreationToUsageTrackingConfig weakTypeDeserializerTracking,
  DataFlow::PathNode deserializeCall2
where
  // all flows from user input to deserialization with weak and strong type serializers
  taintTracking.hasFlowPath(userInput2, deserializeCall) and
  // intersect with strong types, but user controlled or weak types deserialization usages
  (
    userControlledTypeTracking.hasFlowPath(userInput, deserializeCall2) or
    exists(DataFlow::PathNode constructorCall |
      weakTypeDeserializerTracking.hasFlowPath(constructorCall, deserializeCall2)
    )
  ) and
  deserializeCall2.getNode().asExpr().getParent() = deserializeCall.getNode().asExpr().getParent() and
  // exclude deserialization flows with safe instances (i.e. JavaScriptSerializer without resolver)
  not exists(
    DataFlow::PathNode constructor, DataFlow::PathNode usage2,
    SafeConstructorTrackingConfig constructorTracking
  |
    constructorTracking.hasFlowPath(constructor, usage2) and
    usage2.getNode().asExpr().getParent() = deserializeCall.getNode().asExpr().getParent()
  )
  or
  // no type check needed - straightforward taint -> sink
  exists(TaintToConstructorOrStaticMethodTrackingConfig taintTracking2 |
    taintTracking2.hasFlowPath(userInput2, deserializeCall)
  )
select deserializeCall, userInput2, deserializeCall, "$@ flows to unsafe deserializer.", userInput2,
  "User-provided data"