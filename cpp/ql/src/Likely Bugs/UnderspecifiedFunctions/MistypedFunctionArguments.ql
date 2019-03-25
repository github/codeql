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

predicate argTypeMayBePromoted(Type arg, Type parm) {
  arg = parm
  or
  // floating-point and integral promotions
  arg instanceof FloatType and parm instanceof DoubleType
  or
  arg instanceof FloatType and parm instanceof LongDoubleType
  or
  arg instanceof DoubleType and parm instanceof LongDoubleType
  or
  arg instanceof CharType and parm instanceof IntType
  or
  arg instanceof CharType and parm instanceof IntType
  or
  arg instanceof CharType and parm instanceof LongType
  or
  arg instanceof CharType and parm instanceof LongLongType
  or
  arg instanceof ShortType and parm instanceof IntType
  or
  arg instanceof ShortType and parm instanceof LongType
  or
  arg instanceof ShortType and parm instanceof LongLongType
  or
  arg instanceof IntType and parm instanceof LongType
  or
  arg instanceof IntType and parm instanceof LongLongType
  or
  arg instanceof LongType and parm instanceof LongLongType
  or
  arg instanceof Enum and parm instanceof IntType
  or
  arg instanceof Enum and parm instanceof LongType
  or
  arg instanceof Enum and parm instanceof LongLongType
  or
  // enums are usually sized as ints
  arg instanceof IntType and parm instanceof Enum
  or
  // pointer types
  arg.(PointerType).getBaseType().getUnspecifiedType() = parm
        .getUnspecifiedType()
        .(PointerType)
        .getBaseType()
        .getUnspecifiedType()
  or
  // void * parameters accept arbitrary pointer arguments
  arg instanceof PointerType and
  parm.(PointerType).getBaseType().getUnspecifiedType() instanceof VoidType
  or
  // handle reference types
  argTypeMayBePromoted(arg.(ReferenceType).getBaseType().getUnspecifiedType(), parm)
  or
  argTypeMayBePromoted(arg, parm.(ReferenceType).getBaseType().getUnspecifiedType())
  or
  // array-to-pointer decay
  argTypeMayBePromoted(arg.(ArrayType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
  or
  // pointer-to-array promotion (C99)
  argTypeMayBePromoted(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(ArrayType).getBaseType().getUnspecifiedType())
}

// This predicate doesn't necessarily have to exist, but if it does exist
// then it must be inline to make sure we don't enumerate all pairs of
// compatible types.
// Its body could also just be hand-inlined where it's used.
pragma[inline]
predicate argMayBePromoted(Expr arg, Parameter parm) {
  argTypeMayBePromoted(arg.getExplicitlyConverted().getType().getUnspecifiedType(),
    parm.getType().getUnspecifiedType())
  or
  // The value 0 is often passed in to indicate NULL, or to initialize an arbitrary integer type.
  // we will allow all literal values for simplicity.  Pointer parameters are sometime passed
  // special-case literals such as -1, -2, etc.
  arg.(Literal).getType() instanceof IntegralType and
  (
    parm.getType().getUnspecifiedType() instanceof PointerType
    or
    parm.getType().getUnspecifiedType() instanceof IntegralType and
    arg.(Literal).getType().getSize() <= parm.getType().getUnspecifiedType().getSize()
  )
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
  not argMayBePromoted(fc.getArgument(p.getIndex()), p)
select fc, "Calling $@: argument $@ of type $@ is incompatible with parameter $@.", f, f.toString(),
  fc.getArgument(p.getIndex()), fc.getArgument(p.getIndex()).toString(),
  fc.getArgument(p.getIndex()).getType(), fc.getArgument(p.getIndex()).getType().toString(), p,
  p.getTypedName()
