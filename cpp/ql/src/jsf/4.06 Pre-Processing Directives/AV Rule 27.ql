/**
 * @name AV Rule 27
 * @description The #ifndef, #define and #endif directives will be used to prevent multiple inclusions of the same header files. Other techniques to prevent multiple inclusion will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-27
 * @problem.severity warning
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp
import semmle.code.cpp.headers.MultipleInclusion

from BadIncludeGuard bad
select bad.blame(),
  "AV Rule 27: techniques other than #ifndef/#define/#endif will not be used to prevent multiple inclusions of header files."
