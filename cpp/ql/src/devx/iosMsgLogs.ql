/**
 * @name Name: Find ios_msg_*
 * @description Description: Finding all functions with name "ios_msg_*"
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/check-macros
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp
import semmle.code.cpp.commons.Printf


from Function f
where
    f.getName().regexpMatch("ios_msg_*")
select f, "Function name is: "+f.getName().toString()