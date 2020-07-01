/**
 * @name Includes per file
 * @description The number of files directly included by this file using
 *              `#include`.
 * @kind treemap
 * @id cpp/direct-includes-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       modularity
 */

import cpp

from File f, int n
where
  f.fromSource() and
  n = count(Include i | i.getFile() = f)
select f, n
