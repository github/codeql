/**
 * @name Flow Statistics
 * @description Count the number points-to sets with 0 or 1 incoming flow edges, and the total number of points-to sets
 * @kind table
 * @id cpp/points-to/stats
 * @deprecated This query is not suitable for production use and has been deprecated.
 */

import cpp
import semmle.code.cpp.pointsto.PointsTo

predicate inc(int set, int cnt) {
  (setflow(set, _) or setflow(_, set)) and
  cnt = count(int i | setflow(i, set) and i != set)
}

select count(int set | inc(set, _)) as total, count(int set | inc(set, 0)) as nullary,
  count(int set | inc(set, 1)) as unary, total - nullary - unary as rest
