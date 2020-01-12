/**
 * @name Implicit function declaration
 * @description An implicitly declared function is assumed to take no
 * arguments and return an integer. If this assumption does not hold, it
 * may lead to unpredictable behavior.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/implicit-function-declaration
 * @tags correctness
 *       maintainability
 */

import cpp

pragma[inline]
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
predicate argMayBeUsed(Expr arg, ParameterDeclarationEntry pde) {
  argTypeMayBeUsed(arg.getFullyConverted().getUnspecifiedType(), pde.getUnspecifiedType())
}

// True if this file (or header) was compiled as a C file
predicate isCompiledAsC(File f) {
  f.compiledAsC()
  or
  exists(File src | isCompiledAsC(src) | src.getAnIncludedFile() = f)
}

// True if function was ()-declared, but not (void)-declared or K&R-defined
// or implicitly declared (i.e., lacking a prototype)
predicate hasZeroParamDeclTooMany(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.isImplicit() and
    not fde.hasVoidParamList() and
    fde.getNumberOfParameters() = 0 and
    not fde.isDefinition()
  )
}

// True if function was ()-declared, but not (void)-declared or K&R-defined
predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.hasVoidParamList() and fde.getNumberOfParameters() = 0 and not fde.isDefinition()
  )
}

bindingset[name]
predicate notAlreadyReported(string name, FunctionCall fc) {
  forall(FunctionDeclarationEntry fdeEx |
    fdeEx.getName() = name and
    not fdeEx.isImplicit()
  |
    // only report if not reported by cpp/futile-params
    (
      fdeEx.getNumberOfParameters() >= fc.getNumberOfArguments()
      or
      exists(Function f |
        f = fc.getTarget() and
        not exists(f.getBlock())
        or
        not hasZeroParamDeclTooMany(f)
      )
    ) and
    // only report if not reported by cpp/too-few-arguments
    (
      fdeEx.getNumberOfParameters() <= fc.getNumberOfArguments()
      or
      exists(Function f |
        f.isVarargs() or
        f instanceof BuiltInFunction or
        not hasZeroParamDecl(f)
      )
    ) and
    // only report if not reported by cpp/mistyped-function-arguments
    (
      not hasZeroParamDecl(fc.getTarget())
      or
      forall(ParameterDeclarationEntry pde |
        pde = fdeEx.getAParameterDeclarationEntry() and
        pde.getIndex() < fc.getNumberOfArguments()
      |
        argMayBeUsed(fc.getArgument(pde.getIndex()), pde)
      )
    )
  )
}

predicate sameLocation(Location loc1, Location loc2) {
  loc1.getFile() = loc2.getFile() and
  loc1.getStartLine() = loc2.getStartLine() and
  loc1.getStartColumn() = loc2.getStartColumn()
}

from FunctionDeclarationEntry fdeIm, FunctionCall fc
where
  isCompiledAsC(fdeIm.getFile()) and
  fdeIm.isImplicit() and
  sameLocation(fdeIm.getLocation(), fc.getLocation()) and
  notAlreadyReported(fdeIm.getName(), fc)
select fc, "Function call implicitly declares $@", fc, fc.toString()
