/**
 * @name AV Rule 26
 * @description Only the #ifndef, #define, #endif and #include preprocessor directives shall be used.
 * @kind problem
 * @id cpp/jsf/av-rule-26
 * @problem.severity error
 * @tags maintainability
 *       external/jsf
 */

import cpp

from PreprocessorDirective directive
where
  not directive instanceof PreprocessorIfndef and
  not directive instanceof PreprocessorEndif and
  not directive instanceof Macro and
  not directive instanceof Include
select directive,
  "AV Rule 26: only the #ifndef, #endif, #define and #include directives shall be used."
