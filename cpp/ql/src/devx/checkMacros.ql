/**
 * @name Name: Check macros
 * @description Description: Ensure that macros like __FUNCTION__, __FILE__ and __LINE__ are part of only debug logs, and not others.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/check-macros
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp
import semmle.code.cpp.models.interfaces.FormattingFunction

// Find the syslog calls that meet two conditions
// 1. First parameter is not "LOG_DEBUG". Such as LOG_ERR.
// 2. Macros show in log messages.
// Example: syslog(LOG_ERR, "%s: Failed init_producer", __FUNCTION__);

from string format, FormattingFunctionCall fc
where format = fc.getFormat().getValue() and format.regexpMatch(".*LOG_DEBUG.*")
and fc.getTarget().hasName("syslog")
select fc, "This log message format does not meet the requirements."