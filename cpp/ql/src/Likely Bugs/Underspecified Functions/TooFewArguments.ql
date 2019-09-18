/**
 * @name Call to function with fewer arguments than declared parameters
 * @description A function call is passing fewer arguments than the number of
 *              declared parameters of the function. This may indicate
 *              that the code does not follow the author's intent. It is also
 *              a vulnerability, since the function is likely to operate on
 *              undefined data.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id cpp/too-few-arguments
 * @tags correctness
 *       maintainability
 *       security
 */

import cpp

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

from FunctionCall fc, Function f
where
  f = fc.getTarget() and
  not f.isVarargs() and
  not f instanceof BuiltInFunction and
  hasZeroParamDecl(f) and
  isCompiledAsC(f) and
  // There is an explicit declaration of the function whose parameter count is larger
  // than the number of call arguments
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() > fc.getNumberOfArguments()
  )
select fc, "This call has fewer arguments than required by $@.", f, f.toString()
