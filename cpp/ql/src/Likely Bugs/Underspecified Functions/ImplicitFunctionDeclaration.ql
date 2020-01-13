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
import MistypedFunctionArguments
import TooFewArguments
import TooManyArguments
import semmle.code.cpp.commons.Exclusions

predicate sameLocation(Location loc1, Location loc2) {
  loc1.getFile() = loc2.getFile() and
  loc1.getStartLine() = loc2.getStartLine() and
  loc1.getStartColumn() = loc2.getStartColumn()
}

predicate isCompiledAsC(File f) {
  f.compiledAsC()
  or
  exists(File src | isCompiledAsC(src) | src.getAnIncludedFile() = f)
}

from FunctionDeclarationEntry fdeIm, FunctionCall fc
where
  isCompiledAsC(fdeIm.getFile()) and
  not isFromMacroDefinition(fc) and
  fdeIm.isImplicit() and
  sameLocation(fdeIm.getLocation(), fc.getLocation()) and
  not mistypedFunctionArguments(fc, _, _) and
  not tooFewArguments(fc, _) and
  not tooManyArguments(fc, _)
select fc, "Function call implicitly declares $@", fc, fc.toString()
