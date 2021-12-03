/**
 * @name Conflicting HTML element attributes
 * @description If an HTML element has two attributes with the same name
 *              but different values, its behavior may be browser-dependent.
 * @kind problem
 * @problem.severity warning
 * @id js/conflicting-html-attribute
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-758
 * @precision low
 */

import javascript

/**
 * Holds if `earlier` and `later` are attribute definitions with the same name
 * and different values, where `earlier` appears textually before `later`.
 */
predicate conflict(DOM::AttributeDefinition earlier, DOM::AttributeDefinition later) {
  exists(DOM::ElementDefinition elt, int i, int j |
    earlier = elt.getAttribute(i) and later = elt.getAttribute(j)
  |
    i < j and
    earlier.getName() = later.getName() and
    not earlier.getStringValue() = later.getStringValue()
  )
}

from DOM::AttributeDefinition earlier, DOM::AttributeDefinition later
where conflict(earlier, later) and not conflict(_, earlier)
select earlier,
  "This attribute has the same name as $@ of the same element, " + "but a different value.", later,
  "another attribute"
