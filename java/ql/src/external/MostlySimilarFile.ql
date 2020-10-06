/**
 * @deprecated
 * @name Mostly similar file
 * @description Files in which most of the lines are similar to those in another file make code more
 *              difficult to understand and introduce a risk of changes being made to only one copy.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/similar-file
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
where similarFiles(f, other, percent)
select f, percent + "% of the lines in " + f.getStem() + " are similar to lines in $@.", other,
  other.getStem()
