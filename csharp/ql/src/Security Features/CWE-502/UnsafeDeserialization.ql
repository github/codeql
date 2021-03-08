/**
 * @name Unsafe deserializer
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind problem
 * @id cs/unsafe-deserialization
 * @problem.severity warning
 * @precision low
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.UnsafeDeserialization::UnsafeDeserialization

from Call deserializeCall, ObjectMethodSink sink
where
  deserializeCall.getAnArgument() = sink.asExpr() and
  not exists(
    DataFlow::PathNode constructor, DataFlow::PathNode usage,
    SafeConstructorTrackingConfig constructorTracking
  |
    constructorTracking.hasFlowPath(constructor, usage) and
    usage.getNode().asExpr().getParent() = sink.asExpr().getParent()
  )
  or
  exists(ConstructorOrStaticMethodSink sink2 | deserializeCall.getAnArgument() = sink2.asExpr())
select deserializeCall,
  "Unsafe deserializer is used. Make sure the value being deserialized comes from a trusted source."
