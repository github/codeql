/**
 * @deprecated
 * @name Duplicate code
 * @description This block of code is duplicated elsewhere. If possible, the shared code should be refactored so there is only one occurrence left. It may not always be possible to address these issues; other duplicate code checks (such as duplicate function, duplicate class) give subsets of the results with higher confidence.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/duplicate-block
 */

import java

from BlockStmt d, int lines, File otherFile, int otherLine
where none()
select d,
  "Duplicate code: " + lines + " lines are duplicated at " + otherFile.getStem() + ":" + otherLine +
    "."
