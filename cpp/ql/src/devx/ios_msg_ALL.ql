/**
 * @name Name: Find ios_msg_*
 * @description Description: Finding all functions with name "ios_msg_*"
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
    f.getName().regexpMatch("ios_msg_.*")
select f.getACallToThisFunction(), "Function name is: "+f.getName()