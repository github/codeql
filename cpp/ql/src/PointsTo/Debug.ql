/**
 * @name Debug - find out what a particular function-pointer points to
 * @description Query to help investigate mysterious results with ReturnStackAllocatedObject
 * @kind table
 * @id cpp/points-to/debug
 */
import cpp
import semmle.code.cpp.pointsto.PointsTo

class FieldAccessPT extends PointsToExpr
{ override predicate interesting() { this instanceof FieldAccess } }

from Function outer, FieldAccessPT fa
where outer.hasName("rtLnDeliverableMayContainDividends")
  and fa.(FieldAccess).getTarget().hasName("pfFunction")
  and fa.getEnclosingFunction() = outer
select fa, fa.pointsTo()
