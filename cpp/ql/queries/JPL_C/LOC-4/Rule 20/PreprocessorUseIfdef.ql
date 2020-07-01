/**
 * @name Conditional compilation
 * @description The use of conditional compilation directives must be kept to a minimum -- e.g. for header guards only.
 * @kind problem
 * @id cpp/jpl-c/preprocessor-use-ifdef
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from PreprocessorDirective i
where
  (i instanceof PreprocessorIf or i instanceof PreprocessorIfdef or i instanceof PreprocessorIfndef) and
  not i.getFile() instanceof HeaderFile
select i, "Use of conditional compilation must be kept to a minimum."
