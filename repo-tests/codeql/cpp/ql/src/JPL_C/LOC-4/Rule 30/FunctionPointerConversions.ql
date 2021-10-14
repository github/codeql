/**
 * @name Invalid function pointer conversion
 * @description Conversions shall not be performed between a pointer to a function and any type other than an integral type.
 * @kind problem
 * @id cpp/jpl-c/function-pointer-conversions
 * @problem.severity warning
 * @precision low
 * @tags correctness
 *       external/jpl
 */

import cpp

predicate permissibleConversion(Type t) {
  t instanceof IntegralType or
  t instanceof FunctionPointerType or
  permissibleConversion(t.getUnspecifiedType()) or
  permissibleConversion(t.(TypedefType).getBaseType()) or
  permissibleConversion(t.(ReferenceType).getBaseType())
}

from Expr e, Type converted
where
  e.getType() instanceof FunctionPointerType and
  e.getFullyConverted().getType() = converted and
  not permissibleConversion(converted)
select e,
  "Function pointer converted to " + converted.getName() + ", which is not an integral type."
