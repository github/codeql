/**
 * @name Source links for file compilations
 * @kind source-link
 * @id cpp/file-compilation-source-links
 * @metricType fileCompilation
 */

import cpp

from Compilation c, int i
select c.toString() + ":" + i.toString(), c.getFileCompiled(i)
