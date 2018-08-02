/**
 * @name AV Rule 18
 * @description The macro offsetof, in library <stddef.h>, shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-18
 * @problem.severity error
 */
import cpp

from Macro offsetof
where offsetof.getHead().matches("offsetof(%,%)") and
      offsetof.getFile().getAbsolutePath().matches("%stddef.h")
select offsetof.getAnInvocation(), "AV Rule 18: The macro offsetof, in library <stddef.h>, shall not be used."
