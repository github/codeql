/**
 * @name Disallowed preprocessor use
 * @description The use of the preprocessor must be limited to inclusion of header files and simple macro definitions.
 * @kind problem
 * @id cpp/power-of-10/restrict-preprocessor
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/powerof10
 */

import cpp

from PreprocessorDirective p
where
  not p instanceof Include and
  not p instanceof Macro and
  not p instanceof PreprocessorIf and
  not p instanceof PreprocessorElif and
  not p instanceof PreprocessorElse and
  not p instanceof PreprocessorIfdef and
  not p instanceof PreprocessorIfndef and
  not p instanceof PreprocessorEndif
select p, "This preprocessor directive is not allowed."
