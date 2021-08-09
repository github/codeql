/**
 * @name Name: Find ios_errmsg
 * @description Description: Finding all functions with name "ios_errmsg"
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/ios-msg
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp

from Function f
where
    f.getName().regexpMatch("ios_errmsg")
select f.getACallToThisFunction(), "Function name is: "+f.getName()