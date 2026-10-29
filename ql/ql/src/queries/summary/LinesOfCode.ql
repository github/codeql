/**
 * @id ql/summary/lines-of-code
 * @name Total lines of QL code in the database
 * @description The total number of lines of QL code from the source code
 *   directory, including external libraries and auto-generated files. This is a
 *   useful metric of the size of a database. This query counts the lines of
 *   code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 *       lines-of-code
 *       debug
 */

import ql

select sum(File f | exists(f.getRelativePath()) | f.getNumberOfLinesOfCode())
