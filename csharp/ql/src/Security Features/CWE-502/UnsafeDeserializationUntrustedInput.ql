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
  DataFlow::PathNode deserializeCall
where
  // all flows from user input to deserialization with weak and strong type serializers
  taintTracking.hasFlowPath(userInput, deserializeCall) and
  // intersect with strong types, but user controlled or weak types deserialization usages
  (
    exists(
      DataFlow::PathNode weakTypeCreation, DataFlow::PathNode weakTypeUsage,
      WeakTypeCreationToUsageTrackingConfig weakTypeDeserializerTracking
    |
      weakTypeDeserializerTracking.hasFlowPath(weakTypeCreation, weakTypeUsage) and
      weakTypeUsage.getNode().asExpr().getParent() = deserializeCall.getNode().asExpr().getParent()
    )
    or
    exists(
      TaintToObjectTypeTrackingConfig userControlledTypeTracking,
      DataFlow::PathNode taintedTypeUsage, DataFlow::PathNode userInput2
    |
      userControlledTypeTracking.hasFlowPath(userInput2, taintedTypeUsage) and
      taintedTypeUsage.getNode().asExpr().getParent() =
        deserializeCall.getNode().asExpr().getParent()
    )
  ) and
  // exclude deserialization flows with safe instances (i.e. JavaScriptSerializer without resolver)
  not exists(
    SafeConstructorTrackingConfig safeConstructorTracking, DataFlow::PathNode safeCreation,
    DataFlow::PathNode safeTypeUsage
  |
    safeConstructorTracking.hasFlowPath(safeCreation, safeTypeUsage) and
    safeTypeUsage.getNode().asExpr().getParent() = deserializeCall.getNode().asExpr().getParent()
  )
  or
  // no type check needed - straightforward taint -> sink
  exists(TaintToConstructorOrStaticMethodTrackingConfig taintTracking2 |
    taintTracking2.hasFlowPath(userInput, deserializeCall)
  )
select deserializeCall, userInput, deserializeCall, "$@ flows to unsafe deserializer.", userInput,
  "User-provided data"
