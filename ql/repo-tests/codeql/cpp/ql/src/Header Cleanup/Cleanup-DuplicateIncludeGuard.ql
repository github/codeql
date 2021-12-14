/**
 * @name Duplicate include guard
 * @description Using the same include guard macro in more than one header file may cause unexpected behavior from the compiler.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/duplicate-include-guard
 * @tags reliability
 *       maintainability
 *       modularity
 */

import cpp
import semmle.code.cpp.headers.MultipleInclusion

/*
 * A duplicate include guard is an include guard that uses the same macro name as at least
 * one other include guard.  We use hasIncludeGuard, which checks the #ifndef and #endif but
 * not the #define, to identify them (as we expect the #define to be missing from the database
 * in the case of a file that's only ever encountered after other(s) with the same guard macro).
 * However one case must be a correctIncludeGuard to prove that this macro really is intended
 * to be an include guard.
 */

from HeaderFile hf, PreprocessorDirective ifndef, string macroName, int num
where
  hasIncludeGuard(hf, ifndef, _, macroName) and
  exists(HeaderFile other |
    hasIncludeGuard(other, _, _, macroName) and hf.getShortName() != other.getShortName()
  ) and
  num = strictcount(HeaderFile other | hasIncludeGuard(other, _, _, macroName)) and
  correctIncludeGuard(_, _, _, _, macroName)
select ifndef,
  "The macro name '" + macroName + "' of this include guard is used in " + num +
    " different header files."
