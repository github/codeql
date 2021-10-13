/**
 * @name Call to ReferenceEquals(...) on value type expressions
 * @description 'ReferenceEquals(...)' always returns false on value types - its use is at best redundant and at worst erroneous.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/reference-equality-on-valuetypes
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-595
 */

import csharp
import semmle.code.csharp.frameworks.System

from MethodCall c, Method referenceEquals
where
  c.getTarget() = referenceEquals and
  referenceEquals = any(SystemObjectClass o).getReferenceEqualsMethod() and
  c.getArgument(0).stripCasts().getType() instanceof ValueType and
  c.getArgument(1).stripCasts().getType() instanceof ValueType
select c,
  "'ReferenceEquals(...)' always returns false on value types - this check is at best redundant and at worst erroneous."
