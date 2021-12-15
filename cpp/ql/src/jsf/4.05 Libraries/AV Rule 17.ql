/**
 * @name AV Rule 17
 * @description The error indicator errno shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-17
 * @problem.severity error
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Locatable errno, Locatable use
where
  (
    errno.(Macro).getHead() = "errno" and use = errno.(Macro).getAnInvocation()
    or
    errno.(Variable).hasName("errno") and use = errno.(Variable).getAnAccess()
  ) and
  errno.getFile().getAbsolutePath().matches("%errno.h")
select use, "AV Rule 17: The error indicator errno shall not be used."
