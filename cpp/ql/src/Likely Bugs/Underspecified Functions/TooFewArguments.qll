/**
 * Provides the implementation of the TooFewArguments query. The
 * query is implemented as a library, so that we can avoid producing
 * duplicate results in other similar queries.
 */

import cpp

/**
 * Holds if `fde` has a parameter declaration that's clear on the minimum
 * number of parameters. This is essentially true for everything except
 * `()`-declarations.
 */
private predicate hasDefiniteNumberOfParameters(FunctionDeclarationEntry fde) {
  fde.hasVoidParamList()
  or
  fde.getNumberOfParameters() > 0
  or
  fde.isDefinition()
}

/* Holds if function was ()-declared, but not (void)-declared or K&R-defined. */
private predicate hasZeroParamDecl(Function f) {
  exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() |
    not hasDefiniteNumberOfParameters(fde)
  )
}

/* Holds if this file (or header) was compiled as a C file. */
private predicate isCompiledAsC(File f) {
  f.compiledAsC()
  or
  exists(File src | isCompiledAsC(src) | src.getAnIncludedFile() = f)
}

/** Holds if `fc` is a call to `f` with too few arguments. */
predicate tooFewArguments(FunctionCall fc, Function f) {
  f = fc.getTarget() and
  not f.isVarargs() and
  not f instanceof BuiltInFunction and
  // This query should only have results on C (not C++) functions that have a
  // `()` parameter list somewhere. If it has results on other functions, then
  // it's probably because the extractor only saw a partial compilation.
  hasZeroParamDecl(f) and
  isCompiledAsC(f.getFile()) and
  // Produce an alert when all declarations that are authoritative on the
  // parameter count specify a parameter count larger than the number of call
  // arguments.
  forex(FunctionDeclarationEntry fde |
    fde = f.getADeclarationEntry() and
    hasDefiniteNumberOfParameters(fde)
  |
    fde.getNumberOfParameters() > fc.getNumberOfArguments()
  )
}
