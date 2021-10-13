/**
 * @name Implicit function declaration
 * @description An implicitly declared function is assumed to take no
 * arguments and return an integer. If this assumption does not hold, it
 * may lead to unpredictable behavior.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/implicit-function-declaration
 * @tags correctness
 *       maintainability
 */

import cpp
import MistypedFunctionArguments
import TooFewArguments
import TooManyArguments
import semmle.code.cpp.commons.Exclusions

predicate locInfo(Locatable e, File file, int line, int col) {
  e.getFile() = file and
  e.getLocation().getStartLine() = line and
  e.getLocation().getStartColumn() = col
}

predicate sameLocation(FunctionDeclarationEntry fde, FunctionCall fc) {
  exists(File file, int line, int col |
    locInfo(fde, file, line, col) and
    locInfo(fc, file, line, col)
  )
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
  sameLocation(fdeIm, fc) and
  not mistypedFunctionArguments(fc, _, _) and
  not tooFewArguments(fc, _) and
  not tooManyArguments(fc, _)
select fc, "Function call implicitly declares '" + fdeIm.getName() + "'."
