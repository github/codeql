/**
 * @deprecated
 * @name Mostly duplicate file
 * @description Files in which most of the lines are duplicated in another file make code more
 *              difficult to understand and introduce a risk of changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/duplicate-file
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import java
import CodeDuplication

from File f, File other, int percent
where duplicateFiles(f, other, percent)
select f, percent + "% of the lines in " + f.getStem() + " are copies of lines in $@.", other,
  other.getStem()
