/**
 * @name Dangerous system functions
 * @description The library functions abort, exit, getenv and system from library <stdlib.h> should not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-24
 * @problem.severity warning
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

from Function f
where
  f.getName().regexpMatch("abort|exit|getenv|system") and
  f.getFile().getAbsolutePath().matches("%stdlib.h")
select f.getACallToThisFunction(),
  "The library functions abort, exit, getenv and system from library <stdlib.h> should not be used."
