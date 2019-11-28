/**
 * @name Call to function with extraneous arguments
 * @description A function call to a function passed more arguments than there are
 *              declared parameters of the function.  This may indicate
 *              that the code does not follow the author's intent.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/futile-params
 * @tags correctness
 *       maintainability
 */

import cpp

// True if function was ()-declared, but not (void)-declared or K&R-defined
// or implicitly declared (i.e., lacking a prototype)
predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.isImplicit() and
    not fde.hasVoidParamList() and
    fde.getNumberOfParameters() = 0 and
    not fde.isDefinition()
  )
}

// True if this file (or header) was compiled as a C file
predicate isCompiledAsC(File f) {
  f.compiledAsC()
  or
  exists(File src | isCompiledAsC(src) | src.getAnIncludedFile() = f)
}

from FunctionCall fc, Function f
where
  f = fc.getTarget() and
  not f.isVarargs() and
  hasZeroParamDecl(f) and
  isCompiledAsC(f.getFile()) and
  exists(f.getBlock()) and
  // There must not exist a declaration with the number of parameters
  // at least as large as the number of call arguments
  not exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() >= fc.getNumberOfArguments()
  )
select fc, "This call has more arguments than required by $@.", f, f.toString()
