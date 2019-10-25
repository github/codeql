/**
 * @name PrepareStagedPointsTo
 * @description Query to force evaluation of staged points-to predicates
 * @kind table
 * @id cpp/points-to/prepared-staged-points-to
 * @deprecated This query is not suitable for production use and has been deprecated.
 */

import semmle.code.cpp.pointsto.PointsTo

select count(int set, Element location | setlocations(set, unresolveElement(location))),
  count(int set, Element element | pointstosets(set, unresolveElement(element)))
