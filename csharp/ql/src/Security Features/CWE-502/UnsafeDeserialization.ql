/**
 * @name Unsafe deserializer
 * @description Calling an unsafe deserializer with data controlled by an attacker
 *              can lead to denial of service and other security problems.
 * @kind problem
 * @id cs/unsafe-deserialization
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-502
 */

/*
 * consider: @precision low
 */

import csharp
import UnsafeDeserialization

from Call deserializeCall, UnsafeDeserialization::Sink sink
where deserializeCall.getAnArgument() = sink.asExpr()
select deserializeCall,
  "Unsafe deserializer is used. Make sure the value being deserialized comes from a trusted source."
