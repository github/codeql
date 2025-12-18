/**
 * @id cpp/microsoft/public/sizeof/sizeof-or-operation-as-argument
 * @name Usage of an expression that is a binary operation, or sizeof call passed as an argument to a sizeof call
 * @description When the `expr` passed to `sizeof` is a binary operation, or a sizeof call, this is typically a sign that there is a confusion on the usage of sizeof.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags security
 */

import cpp
import SizeOfTypeUtils

predicate isIgnorableBinaryOperation(BinaryOperation op) {
  // FP case: precompilation type checking idiom of the form:
  //    sizeof((type *)0 == (ptr))
  op instanceof EqualityOperation and
  exists(Literal zeroOperand, Expr other, Type t |
    other = op.getAnOperand() and
    other != zeroOperand and
    zeroOperand = op.getAnOperand() and
    zeroOperand.getValue().toInt() = 0 and
    zeroOperand.getImplicitlyConverted().hasExplicitConversion() and
    zeroOperand.getExplicitlyConverted().getUnspecifiedType() = t and
    // often 'NULL' is defined as (void *)0, ignore these cases
    not t instanceof VoidPointerType and
    // Note Function pointers are not considered PointerType
    // casting a wider net here and saying the 'other' cannot be a
    // derived type, which is probably too wide, but I think anything
    //loosely matching this pattern should be ignored.
    other.getUnspecifiedType() instanceof DerivedType
  )
}

class CandidateOperation extends Operation {
  CandidateOperation() {
    // For now only considering binary operations
    // TODO: Unary operations may be of interest but need special care
    // as pointer deref, and address-of are unary operations.
    // It is therefore more likely to get false positives if unary operations are included.
    // To be considered in the future.
    this instanceof BinaryOperation and
    not isIgnorableBinaryOperation(this)
  }
}

from CandidateSizeofCall sizeofExpr, string inMacro, string argType, Expr op
where
  (
    op instanceof CandidateOperation and argType = "binary operator"
    or
    op instanceof SizeofOperator and argType = "sizeof operation"
  ) and
  (if sizeofExpr.isInMacroExpansion() then inMacro = " (in a macro expansion) " else inMacro = " ") and
  op = sizeofExpr.getExprOperand()
select sizeofExpr, "sizeof" + inMacro + "has a " + argType + " argument: $@.", op, op.toString()
