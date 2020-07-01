/**
 * @name Compilation time
 * @description Measures the amount of time (in milliseconds) spent
 *              compiling a C/C++ file, including time spent processing
 *              all files included by the pre-processor.
 * @kind treemap
 * @id cpp/time-in-frontend-per-file
 * @metricType fileCompilation
 * @metricAggregate avg sum max
 * @tags maintainability
 *       testability
 */

import cpp

from string x, float t
where
  exists(Compilation c, int i |
    x = c.toString() + ":" + i.toString() and
    t = 1000 * c.getFrontendCpuSeconds(i) and
    c.getFileCompiled(i).fromSource()
  )
select x, t order by t desc
