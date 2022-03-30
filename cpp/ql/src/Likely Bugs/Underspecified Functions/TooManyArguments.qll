/**
 * Provides the implementation of the TooManyArguments query. The
 * query is implemented as a library, so that we can avoid producing
 * duplicate results in other similar queries.
 */

import cpp

// True if function was ()-declared, but not (void)-declared or K&R-defined
// or implicitly declared (i.e., lacking a prototype)
private predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not fde.isImplicit() and
    not fde.hasVoidParamList() and
    fde.getNumberOfParameters() = 0 and
    not fde.isDefinition()
  )
}

// True if this file (or header) was compiled as a C file
private predicate isCompiledAsC(File f) {
  f.compiledAsC()
  or
  exists(File src | isCompiledAsC(src) | src.getAnIncludedFile() = f)
}

predicate tooManyArguments(FunctionCall fc, Function f) {
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
}
