/**
 * @deprecated
 * @name Mostly similar file
 * @description There is another file that shares a lot of the code with this file. Notice that names of variables and types may have been changed. Merge the two files to improve maintainability.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/similar-file
 * @tags testability
 *       maintainability
 *       useless-code
 *       duplicate-code
 *       statistical
 *       non-attributable
 */

import csharp
import CodeDuplication

predicate irrelevant(File f) {
  f.getStem() = "AssemblyInfo" or
  f.getStem().matches("%.Designer")
}

from File f, File other, int percent
where
  similarFiles(f, other, percent) and
  not irrelevant(f) and
  not irrelevant(other)
select f, percent + "% of the lines in " + f.getBaseName() + " are similar to lines in $@.", other,
  other.getBaseName()
