/**
 * @name Deserialized delegate
 * @description Deserializing a delegate allows for remote code execution when an
 *              attacker can control the serialized data.
 * @kind problem
 * @id cs/deserialized-delegate
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-502
 */

import csharp
import semmle.code.csharp.frameworks.system.linq.Expressions
import semmle.code.csharp.serialization.Deserializers

from Call deserialization, Cast cast
where
  deserialization.getTarget() instanceof UnsafeDeserializer and
  cast.getExpr() = deserialization and
  cast.getTargetType() instanceof SystemLinqExpressions::DelegateExtType
select deserialization, "Deserialization of delegate type."
