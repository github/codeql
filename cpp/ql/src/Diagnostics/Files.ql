/**
 * @name Total source files
 * @description The total number of source files.
 * @kind metric
 * @id cpp/metrics/files
 */

import cpp

select count(File f | f.fromSource())
