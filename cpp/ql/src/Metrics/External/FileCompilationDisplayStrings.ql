/**
 * @name Display strings for file compilations
 * @kind display-string
 * @id cpp/file-compilation-display-strings
 * @metricType fileCompilation
 */

import cpp

from Compilation c, int i
select c.toString() + ":" + i.toString(),
  c.toString() + ":" + i.toString() + ":" + c.getFileCompiled(i)
