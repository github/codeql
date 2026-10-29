/**
 * @name Duplicate property
 * @description Listing the same property twice in one object literal is
 *              redundant and may indicate a copy-paste mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/duplicate-property
 * @tags quality
 *       maintainability
 *       readability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import Clones

bindingset[init]
pragma[inline_late]
private Property getPropertyFromInitializerStrict(Expr init) { result.getInit() = init }

pragma[nomagic]
private predicate duplicateProperties(
  DuplicatePropertyInitDetector dup, Property prop1, Property prop2
) {
  exists(Expr init2 |
    dup.same(init2) and
    prop1 = getPropertyFromInitializerStrict(dup) and
    prop2 = getPropertyFromInitializerStrict(init2)
  )
}

from ObjectExpr oe, int i, int j, Property p, Property q, DuplicatePropertyInitDetector dpid
where
  duplicateProperties(dpid, p, q) and
  p = oe.getProperty(i) and
  q = oe.getProperty(j) and
  i < j and
  // only report the next duplicate
  not exists(int mid | mid in [i + 1 .. j - 1] | dpid.same(oe.getProperty(mid).getInit()))
select p, "This property is duplicated $@.", q, "in a later property"
