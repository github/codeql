/**
 * @name Call to a function with one or more incompatible arguments
 * @description A call to a function with at least one argument whose type does
 * not match the type of the corresponding function parameter.  This may indicate
 * that the author is not familiar with the function being called.  Passing mistyped
 * arguments on a stack may lead to unpredictable function behavior.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/mistyped-function-arguments
 * @tags correctness
 *       maintainability
 */

import cpp

pragma[inline]
int sizeofInt() { result = any(IntType pt).getSize() }

pragma[inline]
predicate pointerArgTypeMayBeUsed(Type arg, Type parm) {
  arg = parm
  or
  // arithmetic types
  arg instanceof ArithmeticType and
  parm instanceof ArithmeticType and
  arg.getSize() = parm.getSize() and
  (
    (
      arg instanceof IntegralType and
      parm instanceof IntegralType
    )
    or
    (
      arg instanceof FloatingPointType and
      parm instanceof FloatingPointType
    )
  )
  or
  // pointers to void are ok
  arg instanceof VoidType
  or
  parm instanceof VoidType
}

pragma[inline]
predicate argTypeMayBeUsed(Type arg, Type parm) {
  arg = parm
  or
  // float will be promoted to double, and so it should correspond
  // to the prototype
  arg instanceof FloatType and parm instanceof DoubleType
  or
  // integral types are promoted "up to" (unsigned) int, but not long long.
  arg instanceof IntegralType and
  parm instanceof IntegralType and
  arg.getSize() <= sizeofInt() and
  parm.getSize() <= sizeofInt()
  or
  /*
   *  // we allow interoperability between long long and pointer
   *  arg.getSize() = parm.getSize() and
   *  (
   *    (arg instanceof IntegralType and parm instanceof PointerType)
   *    or
   *    (arg instanceof PointerType and parm instanceof IntegralType)
   *  )
   *  or
   */

  // pointers to compatible types
  pointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
  or
  pointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(ArrayType).getBaseType().getUnspecifiedType())
  or
  pointerArgTypeMayBeUsed(arg.(ArrayType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
  or
  pointerArgTypeMayBeUsed(arg.(ArrayType).getBaseType().getUnspecifiedType(),
    parm.(ArrayType).getBaseType().getUnspecifiedType())
}

// This predicate doesn't necessarily have to exist, but if it does exist
// then it must be inline to make sure we don't enumerate all pairs of
// compatible types.
// Its body could also just be hand-inlined where it's used.
pragma[inline]
predicate argMayBeUsed(Expr arg, Parameter parm) {
  argTypeMayBeUsed(arg.getFullyConverted().getType().getUnspecifiedType(),
    parm.getType().getUnspecifiedType())
}

from FunctionCall fc, Function f, Parameter p
where
  f = fc.getTarget() and
  p = f.getAParameter() and
  not f.isVarargs() and
  p.getIndex() < fc.getNumberOfArguments() and
  // There must be a zero-parameter declaration
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() = 0
  ) and
  // Parameter p and its corresponding call argument must have mismatched types
  not argMayBeUsed(fc.getArgument(p.getIndex()), p)
select fc, "Calling $@: argument $@ of type $@ is incompatible with parameter $@.", f, f.toString(),
  fc.getArgument(p.getIndex()) as arg, arg.toString(), arg.getFullyConverted().getType() as type,
  type.toString(), p, p.getTypedName()
