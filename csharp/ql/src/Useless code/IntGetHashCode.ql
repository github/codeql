/**
 * @name Useless call to GetHashCode()
 * @description Calling 'GetHashCode()' on integer types is redundant because the method always returns
 *              the original value.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/useless-gethashcode-call
 * @tags quality
 *       maintainability
 *       readability
 *       useless-code
 */

import csharp
import semmle.code.csharp.frameworks.System

from MethodCall mc, IntegralType t
where
  mc.getTarget() instanceof GetHashCodeMethod and
  t = mc.getQualifier().getType() and
  (
    t instanceof ByteType or
    t instanceof SByteType or
    t instanceof ShortType or
    t instanceof UShortType or
    t instanceof IntType
  )
select mc, "Calling GetHashCode() on type " + t.toStringWithTypes() + " is redundant."
