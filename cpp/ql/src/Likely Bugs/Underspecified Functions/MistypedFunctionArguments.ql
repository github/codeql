/**
 * @name Call to a function with one or more incompatible arguments
 * @description A call to a function with at least one argument whose type does
 * not match the type of the corresponding function parameter.  This may indicate
 * that the author is not familiar with the function being called.  Passing mistyped
 * arguments on a stack may lead to unpredictable function behavior.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/mistyped-function-arguments
 * @tags correctness
 *       maintainability
 */

import cpp

pragma[inline]
predicate pointerArgTypeMayBeUsed(Type arg, Type parm) {
  arg = parm
  or
  // arithmetic types
  arg instanceof ArithmeticType and
  parm instanceof ArithmeticType and
  arg.getSize() = parm.getSize() and
  (
    arg instanceof IntegralType and
    parm instanceof IntegralType
    or
    arg instanceof FloatingPointType and
    parm instanceof FloatingPointType
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
  // float arguments will have been promoted to double,
  // and the parameter must match this
  arg instanceof DoubleType and
  parm instanceof DoubleType
  or
  // integral arguments are promoted to int (but not long long).
  arg instanceof IntegralType and
  arg.getSize() = 4 and
  parm instanceof IntegralType and
  parm.getSize() = 4
  or
  // pointers to compatible types
  pointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnderlyingType().getUnspecifiedType())
  or
  pointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(ArrayType).getBaseType().getUnderlyingType().getUnspecifiedType())
}

// This predicate doesn't necessarily have to exist, but if it does exist
// then it must be inline to make sure we don't enumerate all pairs of
// compatible types.
// Its body could also just be hand-inlined where it's used.
pragma[inline]
predicate argMayBeUsed(Expr arg, Parameter parm) {
  argTypeMayBeUsed(arg.getFullyConverted().getType().getUnderlyingType().getUnspecifiedType(),
    parm.getType().getUnderlyingType().getUnspecifiedType())
}

// True if function was ()-declared, but not (void)-declared
pragma[inline]
predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.hasVoidParamList() and fde.getNumberOfParameters() = 0
  )
}

from FunctionCall fc, Function f, Parameter p
where
  f = fc.getTarget() and
  p = f.getAParameter() and
  not f.isVarargs() and
  p.getIndex() < fc.getNumberOfArguments() and
  hasZeroParamDecl(f) and
  // Parameter p and its corresponding call argument must have mismatched types
  not argMayBeUsed(fc.getArgument(p.getIndex()), p)
select fc, "Calling $@: argument $@ of type $@ is incompatible with parameter $@", f, f.toString(),
  fc.getArgument(p.getIndex()) as arg, arg.toString(),
  arg.getFullyConverted().getType().getUnderlyingType().getUnspecifiedType() as atype,
  atype.toString(), p, p.getTypedName()
