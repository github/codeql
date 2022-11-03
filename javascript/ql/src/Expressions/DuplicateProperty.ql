/**
 * @name Duplicate property
 * @description Listing the same property twice in one object literal is
 *              redundant and may indicate a copy-paste mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/duplicate-property
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import Clones

from ObjectExpr oe, int i, int j, Property p, Property q, DuplicatePropertyInitDetector dpid
where
  p = oe.getProperty(i) and
  q = oe.getProperty(j) and
  dpid = p.getInit() and
  dpid.same(q.getInit()) and
  i < j and
  // only report the next duplicate
  not exists(int mid | mid in [i + 1 .. j - 1] | dpid.same(oe.getProperty(mid).getInit()))
select p, "This property is duplicated $@.", q, "here"
