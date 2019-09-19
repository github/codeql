/**
 * @name Call to a function with one or more incompatible arguments
 * @description When the type of a function argument is not compatible
 * with the type of the corresponding parameter, it may lead to
 * unpredictable behavior.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/mistyped-function-arguments
 * @tags correctness
 *       maintainability
 */

import cpp

predicate arithTypesMatch(Type arg, Type parm) {
  arg = parm
  or
  arg.getSize() = parm.getSize() and
  (
    arg instanceof IntegralOrEnumType and
    parm instanceof IntegralOrEnumType
    or
    arg instanceof FloatingPointType and
    parm instanceof FloatingPointType
  )
}

pragma[inline]
predicate nestedPointerArgTypeMayBeUsed(Type arg, Type parm) {
  // arithmetic types
  arithTypesMatch(arg, parm)
  or
  // conversion to/from pointers to void is allowed
  arg instanceof VoidType
  or
  parm instanceof VoidType
}

pragma[inline]
predicate pointerArgTypeMayBeUsed(Type arg, Type parm) {
  nestedPointerArgTypeMayBeUsed(arg, parm)
  or
  // nested pointers
  nestedPointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
  or
  nestedPointerArgTypeMayBeUsed(arg.(ArrayType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
}

pragma[inline]
predicate argTypeMayBeUsed(Type arg, Type parm) {
  // arithmetic types
  arithTypesMatch(arg, parm)
  or
  // pointers to compatible types
  pointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
  or
  pointerArgTypeMayBeUsed(arg.(ArrayType).getBaseType().getUnspecifiedType(),
    parm.(PointerType).getBaseType().getUnspecifiedType())
  or
  // C11 arrays
  pointerArgTypeMayBeUsed(arg.(PointerType).getBaseType().getUnspecifiedType(),
    parm.(ArrayType).getBaseType().getUnspecifiedType())
  or
  pointerArgTypeMayBeUsed(arg.(ArrayType).getBaseType().getUnspecifiedType(),
    parm.(ArrayType).getBaseType().getUnspecifiedType())
}

// This predicate holds whenever expression `arg` may be used to initialize
// function parameter `parm` without need for run-time conversion.
pragma[inline]
predicate argMayBeUsed(Expr arg, Parameter parm) {
  argTypeMayBeUsed(arg.getFullyConverted().getUnspecifiedType(), parm.getUnspecifiedType())
}

// True if function was ()-declared, but not (void)-declared or K&R-defined
predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.hasVoidParamList() and fde.getNumberOfParameters() = 0 and not fde.isDefinition()
  )
}

// True if this file (or header) was compiled as a C file
predicate isCompiledAsC(Function f) {
  exists(File file | file.compiledAsC() |
    file = f.getFile() or file.getAnIncludedFile+() = f.getFile()
  )
}

from FunctionCall fc, Function f, Parameter p
where
  f = fc.getTarget() and
  p = f.getAParameter() and
  hasZeroParamDecl(f) and
  isCompiledAsC(f) and
  not f.isVarargs() and
  not f instanceof BuiltInFunction and
  p.getIndex() < fc.getNumberOfArguments() and
  // Parameter p and its corresponding call argument must have mismatched types
  not argMayBeUsed(fc.getArgument(p.getIndex()), p)
select fc, "Calling $@: argument $@ of type $@ is incompatible with parameter $@.", f, f.toString(),
  fc.getArgument(p.getIndex()) as arg, arg.toString(),
  arg.getExplicitlyConverted().getUnspecifiedType() as atype, atype.toString(), p, p.getTypedName()
