/**
 * @name AV Rule 23
 * @description The library functions atof, atoi and atol from library <stdlib.h> shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-23
 * @problem.severity error
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

from Function f
where
  f.getName().regexpMatch("atof|atoi|atol") and
  f.getFile().getAbsolutePath().matches("%stdlib.h")
select f.getACallToThisFunction(),
  "AV Rule 23: The library functions atof, atoi and atol from library <stdlib.h> shall not be used."
