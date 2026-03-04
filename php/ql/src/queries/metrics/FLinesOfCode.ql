/**
 * @name Lines of code in files
 * @kind metric
 * @description Measures the number of lines of code in each file,
 *              ignoring lines that contain only comments or whitespace.
 * @metricType file
 * @id php/lines-of-code-in-files
 */

import codeql.php.AST

from Program p, int n
where n = p.getLocation().getFile().getNumberOfLinesOfCode()
select p.getLocation().getFile(), n order by n desc
