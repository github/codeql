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
import Flow::PathGraph

module Flow =
  DataFlow::MergePathGraph3<TaintToObjectMethodTracking::PathNode,
    TaintToConstructorOrStaticMethodTracking::PathNode, JsonConvertTracking::PathNode,
    TaintToObjectMethodTracking::PathGraph, TaintToConstructorOrStaticMethodTracking::PathGraph,
    JsonConvertTracking::PathGraph>;

from Flow::PathNode userInput, Flow::PathNode deserializeCallArg
where
  // all flows from user input to deserialization with weak and strong type serializers
  TaintToObjectMethodTracking::flowPath(userInput.asPathNode1(), deserializeCallArg.asPathNode1()) and
  // intersect with strong types, but user controlled or weak types deserialization usages
  (
    exists(DataFlow::Node weakTypeUsage, MethodCall mc |
      WeakTypeCreationToUsageTracking::flowTo(weakTypeUsage) and
      mc.getQualifier() = weakTypeUsage.asExpr() and
      mc.getAnArgument() = deserializeCallArg.getNode().asExpr()
    )
    or
    exists(DataFlow::Node taintedTypeUsage, MethodCall mc |
      TaintToObjectTypeTracking::flowTo(taintedTypeUsage) and
      mc.getQualifier() = taintedTypeUsage.asExpr() and
      mc.getAnArgument() = deserializeCallArg.getNode().asExpr()
    )
  )
  or
  // no type check needed - straightforward taint -> sink
  TaintToConstructorOrStaticMethodTracking::flowPath(userInput.asPathNode2(),
    deserializeCallArg.asPathNode2())
  or
  // JsonConvert static method call, but with additional unsafe typename tracking
  exists(DataFlow::Node settingsCallArg |
    JsonConvertTracking::flowPath(userInput.asPathNode3(), deserializeCallArg.asPathNode3()) and
    TypeNameTracking::flow(_, settingsCallArg) and
    deserializeCallArg.getNode().asExpr().getParent() = settingsCallArg.asExpr().getParent()
  )
select deserializeCallArg, userInput, deserializeCallArg, "$@ flows to unsafe deserializer.",
  userInput, "User-provided data"
