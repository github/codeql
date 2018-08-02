/**
 * @name Similar script
 * @description There is another script that shares a lot of code with this script.
 *              Extract the common parts to a new script to improve maintainability..
 * @kind problem
 * @problem.severity recommendation
 * @id js/similar-script
 * @tags testability
 *       maintainability
 *       useless-code
 *       statistical
 *       non-attributable
 *       duplicate-code
 * @precision medium
 */

import javascript
import CodeDuplication
import semmle.javascript.RestrictedLocations

from TopLevel one, TopLevel another, float percent
where similarContainers(one, another, percent) and
    one.getNumChildStmt() > 5 and
    not duplicateContainers(one, another, _)
select (FirstLineOf)one, percent.floor() + "% of statements in this script are similar to statements in $@.",
   (FirstLineOf)another,
   "another script"