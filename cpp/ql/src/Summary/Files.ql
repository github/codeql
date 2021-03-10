/**
 * @id cpp/summary/files
 * @name Total source files
 * @description The total number of source files.
 * @kind metric
 * @tags summary
 */

import cpp

select count(File f | f.fromSource())
