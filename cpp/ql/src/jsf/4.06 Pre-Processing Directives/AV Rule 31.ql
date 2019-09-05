/**
 * @name AV Rule 31
 * @description The #define directive will only be used as part of the technique to prevent multiple inclusions of the same header file.
 * @kind problem
 * @id cpp/jsf/av-rule-31
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp
import semmle.code.cpp.headers.MultipleInclusion

from Macro macro
where not exists(CorrectIncludeGuard cig | macro = cig.getDefine())
select macro,
  "AV Rule 31: The #define directive will only be used as part of the technique to prevent multiple inclusions of the same header file."
