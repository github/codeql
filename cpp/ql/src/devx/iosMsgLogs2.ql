/**
 * @name Name: Find ios_*msg
 * @description Description: Finding all functions with name "ios_*msg"
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/check-macros
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp

from Function f
where
    f.getName().regexpMatch("ios_*msg")
select f.getACallToThisFunction(), "Function name is: "+f.getName().toString()