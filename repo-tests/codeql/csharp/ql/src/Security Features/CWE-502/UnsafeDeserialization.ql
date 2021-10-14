/**
 * @name Unsafe deserializer
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind problem
 * @id cs/unsafe-deserialization
 * @problem.severity warning
 * @security-severity 9.8
 * @precision low
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.security.dataflow.UnsafeDeserializationQuery

from Call deserializeCall, Sink sink
where deserializeCall.getAnArgument() = sink.asExpr()
select deserializeCall,
  "Unsafe deserializer is used. Make sure the value being deserialized comes from a trusted source."
