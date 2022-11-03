/**
 * @deprecated
 * @name Mostly duplicate file
 * @description There is another file that shares a lot of the code with this file. Merge the two files to improve maintainability.
 * @kind problem
 * @id cpp/duplicate-file
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
where duplicateFiles(f, other, percent)
select f, percent + "% of the lines in " + f.getBaseName() + " are copies of lines in $@.", other,
  other.getBaseName()
