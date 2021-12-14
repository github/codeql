/**
 * @deprecated
 * @name Mostly similar file
 * @description There is another file that shares a lot of the code with this file. Notice that names of variables and types may have been changed. Merge the two files to improve maintainability.
 * @kind problem
 * @id cpp/similar-file
 * @problem.severity recommendation
 * @precision medium
 * @tags testability
 *       maintainability
 *       duplicate-code
 *       non-attributable
 */

import cpp
import CodeDuplication

from File f, File other, int percent
where similarFiles(f, other, percent)
select f, percent + "% of the lines in " + f.getBaseName() + " are similar to lines in $@.", other,
  other.getBaseName()
