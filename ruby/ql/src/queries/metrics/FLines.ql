/**
 * @name Number of lines
 * @kind metric
 * @description The number of lines in each file.
 * @metricType file
 * @id rb/lines-per-file
 */

import codeql.ruby.AST

from RubyFile f, int n
where n = f.getNumberOfLines()
select f, n order by n desc
