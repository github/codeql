/**
 * @name Lines of dead code in files
 * @description The number of lines of dead code in a file.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @id java/lines-of-dead-code
 * @tags maintainability
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.deadcode.DeadCode

from File f, int n
where
  n =
    // Lines of code contributed by dead classes.
    sum(DeadClass deadClass |
        deadClass.getFile() = f
      |
        deadClass.getNumberOfLinesOfCode() -
            // Remove inner and local classes, as they are reported as separate dead classes. Do not
            // remove anonymous classes, because they aren't reported separately.
            sum(NestedClass innerClass |
              innerClass.getEnclosingType() = deadClass and not innerClass.isAnonymous()
            |
              innerClass.getNumberOfLinesOfCode()
            )
      ) +
      // Lines of code contributed by dead methods, not in dead classes.
      sum(DeadMethod deadMethod |
        deadMethod.getFile() = f and not deadMethod.isInDeadScope()
      |
        deadMethod.getNumberOfLinesOfCode() -
            // Remove local classes defined in the dead method - they are reported separately as a dead
            // class. We keep anonymous class counts, because anonymous classes are not reported
            // separately.
            sum(LocalClass localClass |
              localClass.getLocalClassDeclStmt().getEnclosingCallable() = deadMethod
            |
              localClass.getNumberOfLinesOfCode()
            )
      ) +
      // Lines of code contributed by dead fields, not in dead classes.
      sum(DeadField deadField |
        deadField.getFile() = f and not deadField.isInDeadScope()
      |
        deadField.getNumberOfLinesOfCode()
      ) +
      // Lines of code contributed by unused enum constants.
      sum(UnusedEnumConstant deadEnumConstant |
        deadEnumConstant.getFile() = f
      |
        deadEnumConstant.getNumberOfLinesOfCode()
      )
select f, n order by n desc
