/**
 * @name Total source files
 * @description The total number of source files.
 * @kind metric
 * @id js/metrics/files
 */

import javascript

select count(File f | not f.getATopLevel().isExterns())
