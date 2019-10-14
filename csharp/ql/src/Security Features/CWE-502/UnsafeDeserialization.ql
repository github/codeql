/**
 * @name Unsafe deserializer
 * @description Calling an unsafe deserializer can lead to denial of service, remote code execution and other
 *              security problems. This version checks the sink for unsafe deserialization while leaving the source to be any library call
 * @kind problem
 * @id cs/unsafe-deserialization
 * @problem.severity warning
 * @precision low
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.serialization.UnsafeDeserialization::UnsafeDeserializersDataFlow

from UnsafeDeserializationSink deserializeCall
select deserializeCall, "Unsafe deserializer is used. Make sure $@ comes from the trusted source.",
  deserializeCall.asExpr(), "value being deserialized"
