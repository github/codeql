/**
 * @deprecated
 * @name Mostly duplicate file
 * @description There is another file that shares a lot of the code with this file. Merge the two files to improve maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/duplicate-file
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import csharp
import CodeDuplication

from File f, File other, int percent
where duplicateFiles(f, other, percent)
select f, percent + "% of the lines in " + f.getBaseName() + " are copies of lines in $@.", other,
  other.getBaseName()
