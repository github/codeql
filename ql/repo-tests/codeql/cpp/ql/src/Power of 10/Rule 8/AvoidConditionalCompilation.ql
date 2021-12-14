/**
 * @name Conditional compilation
 * @description The use of conditional compilation directives must be kept to a minimum -- e.g. for header guards only.
 * @kind problem
 * @id cpp/power-of-10/avoid-conditional-compilation
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/powerof10
 */

import cpp

from PreprocessorDirective i
where
  (i instanceof PreprocessorIf or i instanceof PreprocessorIfdef or i instanceof PreprocessorIfndef) and
  not i.getFile() instanceof HeaderFile
select i, "Use of conditional compilation must be kept to a minimum."
