/**
 * @id java/summary/lines-of-code-kotlin
 * @name Total lines of Kotlin code in the database
 * @description The total number of lines of code across all Kotlin files. This is a useful metric of the size of a database.
 *              For all Kotlin files that were seen during the build, this query counts the lines of code, excluding whitespace
 *              or comments.
 * @kind metric
 * @tags summary
 *       debug
 */

import java

select sum(CompilationUnit f |
    f.fromSource() and f.isKotlinSourceFile()
  |
    f.getNumberOfLinesOfCode()
  )
