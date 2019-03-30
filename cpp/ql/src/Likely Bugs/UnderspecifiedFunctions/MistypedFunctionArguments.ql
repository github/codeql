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
predicate argTypeMayBeImplicitlyConverted(Type arg, Type parm) {
  arg = parm
  or
  // integral and floating-point types are implicitly convertible in C
  arg instanceof ArithmeticType and parm instanceof ArithmeticType
  or
  // integral values may be used to initialize pointers (but NOT array addresses)
  arg instanceof IntegralType and parm instanceof PointerType
  or
  // pointers-to-void may be used for arbitrary pointers
  arg instanceof VoidPointerType and parm instanceof PointerType
  or
  arg instanceof PointerType and parm instanceof VoidPointerType
  or
  arg instanceof ArrayType and parm instanceof VoidPointerType
  or
  arg instanceof VoidPointerType and parm instanceof ArrayType
  or
  // pointers to same types
  arg.(PointerType).getBaseType().getUnspecifiedType() = parm
        .(PointerType)
        .getBaseType()
        .getUnspecifiedType()
  or
  arg.(ArrayType).getBaseType().getUnspecifiedType() = parm
        .(PointerType)
        .getBaseType()
        .getUnspecifiedType()
  or
  arg.(PointerType).getBaseType().getUnspecifiedType() = parm
        .(ArrayType)
        .getBaseType()
        .getUnspecifiedType()
  or
  arg.(ArrayType).getBaseType().getUnspecifiedType() = parm
        .(ArrayType)
        .getBaseType()
        .getUnspecifiedType()
}

// This predicate doesn't necessarily have to exist, but if it does exist
// then it must be inline to make sure we don't enumerate all pairs of
// compatible types.
// Its body could also just be hand-inlined where it's used.
pragma[inline]
predicate argMayBeImplicitlyConverted(Expr arg, Parameter parm) {
  argTypeMayBeImplicitlyConverted(arg.getFullyConverted().getType().getUnspecifiedType(),
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
  not argMayBeImplicitlyConverted(fc.getArgument(p.getIndex()), p)
select fc, "Calling $@: argument $@ of type $@ is incompatible with parameter $@.", f, f.toString(),
  fc.getArgument(p.getIndex()) as arg, arg.toString(), arg.getFullyConverted().getType() as type,
  type.toString(), p, p.getTypedName()
