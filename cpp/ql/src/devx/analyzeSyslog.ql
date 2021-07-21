/**
 * @name Name: Analyze syslog
 * @description Description: test
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/analyze-syslog
 * @tags testability
 *       readability
 *       maintainability
 */



import cpp
import semmle.code.cpp.models.interfaces.FormattingFunction

from string format, FormattingFunctionCall fc
where format = fc.getFormat().getValue() and format.regexpMatch(".*")
and fc.getTarget().hasName("syslog")
select fc, "This log message format does not meet the requirements."