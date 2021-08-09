/**
 * @name Name: Find ios_debugmsg
 * @description Description: Finding all functions with name "ios_debugmsg"
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
    f.getName().regexpMatch("ios_debugmsg")
select f.getACallToThisFunction(), "Function name is: "+f.getName()