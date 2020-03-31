/**
 * Provides the implementation of the TooFewArguments query. The
 * query is implemented as a library, so that we can avoid producing
 * duplicate results in other similar queries.
 */

import cpp

// True if function was ()-declared, but not (void)-declared or K&R-defined
private predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.hasVoidParamList() and fde.getNumberOfParameters() = 0 and not fde.isDefinition()
  )
}

// True if this file (or header) was compiled as a C file
private predicate isCompiledAsC(File f) {
  f.compiledAsC()
  or
  exists(File src | isCompiledAsC(src) | src.getAnIncludedFile() = f)
}

predicate tooFewArguments(FunctionCall fc, Function f) {
  f = fc.getTarget() and
  not f.isVarargs() and
  not f instanceof BuiltInFunction and
  hasZeroParamDecl(f) and
  isCompiledAsC(f.getFile()) and
  // There is an explicit declaration of the function whose parameter count is larger
  // than the number of call arguments
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    fde.getNumberOfParameters() > fc.getNumberOfArguments()
  )
}
