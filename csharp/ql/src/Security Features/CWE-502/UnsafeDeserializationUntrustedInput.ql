/**
 * @name Deserialization of untrusted data
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind path-problem
 * @id cs/unsafe-deserialization-untrusted-input
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.UnsafeDeserializationQuery
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
      WeakTypeCreationToUsageTrackingConfig weakTypeDeserializerTracking, MethodCall mc
    |
      weakTypeDeserializerTracking.hasFlow(weakTypeCreation, weakTypeUsage) and
      mc.getQualifier() = weakTypeUsage.asExpr() and
      mc.getAnArgument() = deserializeCallArg.getNode().asExpr()
    )
    or
    exists(
      TaintToObjectTypeTrackingConfig userControlledTypeTracking, DataFlow::Node taintedTypeUsage,
      DataFlow::Node userInput2, MethodCall mc
    |
      userControlledTypeTracking.hasFlow(userInput2, taintedTypeUsage) and
      mc.getQualifier() = taintedTypeUsage.asExpr() and
      mc.getAnArgument() = deserializeCallArg.getNode().asExpr()
    )
  )
  or
  // no type check needed - straightforward taint -> sink
  exists(TaintToConstructorOrStaticMethodTrackingConfig taintTracking2 |
    taintTracking2.hasFlowPath(userInput, deserializeCallArg)
  )
  or
  // JsonConvert static method call, but with additional unsafe typename tracking
  exists(
    JsonConvertTrackingConfig taintTrackingJsonConvert, TypeNameTrackingConfig typenameTracking,
    DataFlow::Node settingsCallArg
  |
    taintTrackingJsonConvert.hasFlowPath(userInput, deserializeCallArg) and
    typenameTracking.hasFlow(_, settingsCallArg) and
    deserializeCallArg.getNode().asExpr().getParent() = settingsCallArg.asExpr().getParent()
  )
select deserializeCallArg, userInput, deserializeCallArg, "$@ flows to unsafe deserializer.",
  userInput, "User-provided data"
