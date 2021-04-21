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

from DataFlow::PathNode userInput, DataFlow::PathNode deserializeCallArg
where
  exists(TaintToObjectMethodTrackingConfig taintTracking |
    // all flows from user input to deserialization with weak and strong type serializers
    taintTracking.hasFlowPath(userInput, deserializeCallArg)
  ) and
  // intersect with strong types, but user controlled or weak types deserialization usages
  (
    exists(
      DataFlow::Node weakTypeCreation, DataFlow::Node weakTypeUsage,
      WeakTypeCreationToUsageTrackingConfig weakTypeDeserializerTracking
    |
      weakTypeDeserializerTracking.hasFlow(weakTypeCreation, weakTypeUsage) and
      weakTypeUsage.asExpr().getParent() = deserializeCallArg.getNode().asExpr().getParent()
    )
    or
    exists(
      TaintToObjectTypeTrackingConfig userControlledTypeTracking, DataFlow::Node taintedTypeUsage,
      DataFlow::Node userInput2
    |
      userControlledTypeTracking.hasFlow(userInput2, taintedTypeUsage) and
      taintedTypeUsage.asExpr().getParent() = deserializeCallArg.getNode().asExpr().getParent()
    )
  ) and
  // exclude deserialization flows with safe instances (i.e. JavaScriptSerializer without resolver)
  not exists(
    SafeConstructorTrackingConfig safeConstructorTracking, DataFlow::Node safeCreation,
    DataFlow::Node safeTypeUsage
  |
    safeConstructorTracking.hasFlow(safeCreation, safeTypeUsage) and
    safeTypeUsage.asExpr().getParent() = deserializeCallArg.getNode().asExpr().getParent()
  )
  or
  // no type check needed - straightforward taint -> sink
  exists(TaintToConstructorOrStaticMethodTrackingConfig taintTracking2 |
    taintTracking2.hasFlowPath(userInput, deserializeCallArg)
  )
select deserializeCallArg, userInput, deserializeCallArg, "$@ flows to unsafe deserializer.",
  userInput, "User-provided data"
