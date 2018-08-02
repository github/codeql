/**
 * @name Duplicate script
 * @description There is another script that shares a lot of code with this script. Consider combining the
 *              two scripts to improve maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @id js/duplicate-script
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
where duplicateContainers(one, another, percent) and
      one.getNumLines() > 5
select (FirstLineOf)one, percent + "% of statements in this script are duplicated in $@.", (FirstLineOf)another, "another script"
