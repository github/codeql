/**
 * @name Duplicate HTML element attributes
 * @description Specifying the same attribute twice on the same HTML element is
 *              redundant and may indicate a copy-paste mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/duplicate-html-attribute
 * @tags maintainability
 *       readability
 * @precision very-high
 */

import javascript

/**
 * Holds if `earlier` and `later` are attribute definitions with the same name
 * and the same value, where `earlier` appears textually before `later`.
 */
predicate duplicate(DOM::AttributeDefinition earlier, DOM::AttributeDefinition later) {
  exists(DOM::ElementDefinition elt, int i, int j |
    earlier = elt.getAttribute(i) and later = elt.getAttribute(j)
  |
    i < j and
    earlier.getName() = later.getName() and
    earlier.getStringValue() = later.getStringValue()
  )
}

from DOM::AttributeDefinition earlier, DOM::AttributeDefinition later
where duplicate(earlier, later) and not duplicate(_, earlier)
select earlier, "This attribute is duplicated $@.", later, "here"
