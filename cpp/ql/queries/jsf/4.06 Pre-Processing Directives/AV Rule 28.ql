/**
 * @name AV Rule 28
 * @description The #ifndef and #endif directives will only be used as defined in AV Rule 27 to prevent multiple inclusions of the same header file.
 * @kind problem
 * @id cpp/jsf/av-rule-28
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp
import semmle.code.cpp.headers.MultipleInclusion

from PreprocessorDirective directive
where
  (directive instanceof PreprocessorIfndef or directive instanceof PreprocessorEndif) and
  not exists(CorrectIncludeGuard cig | directive = cig.getIfndef() or directive = cig.getEndif())
select directive,
  "AV Rule 28: the #ifndef and #endif directives will only be used as defined in AV Rule 27."
