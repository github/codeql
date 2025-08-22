/**
 * @id java/summary/lines-of-code
 * @name Total lines of Java/Kotlin code in the database
 * @description The total number of lines of code across all Java and Kotlin files. This is a useful metric of the size of a database.
 *              For all source files that were seen during the build, this query counts the lines of code, excluding whitespace
 *              or comments.
 * @kind metric
 * @tags summary
 *       lines-of-code
 *       debug
 */

import java

select sum(CompilationUnit f | f.fromSource() | f.getNumberOfLinesOfCode())
