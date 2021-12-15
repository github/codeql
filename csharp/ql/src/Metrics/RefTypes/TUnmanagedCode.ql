/**
 * @name Types containing unmanaged code
 * @description Counts the number of "extern" methods, implemented by unmanaged code, per class.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate sum
 * @tags reliability
 * @id cs/externs-per-type
 */

import csharp

from Class c, Method m
where
  m.hasModifier("extern") and
  m.getDeclaringType() = c
select c, 1
