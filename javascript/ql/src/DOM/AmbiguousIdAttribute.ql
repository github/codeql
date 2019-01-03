/**
 * @name Ambiguous HTML id attribute
 * @description If an HTML document contains two elements with the
 *              same id attribute, it may be interpreted differently
 *              by different browsers.
 * @kind problem
 * @problem.severity warning
 * @id js/duplicate-html-id
 * @tags maintainability
 *       correctness
 * @precision very-high
 */

import javascript

/**
 * Holds if `attr` is an id attribute with value `id` of a DOM element
 * under document `root` at the given `line` and `column`.
 *
 * Furthermore, the id is required to be valid, and not look like a template.
 */
predicate idAt(DOM::AttributeDefinition attr, string id, DOM::ElementDefinition root, int line, int column) {
  exists (DOM::ElementDefinition elt |
    attr = elt.getAttributeByName("id") |
    id = attr.getStringValue() and
    root = elt.getRoot() and
    elt.getLocation().hasLocationInfo(_, line, column, _, _) and
    not (
      // exclude invalid ids (reported by another query)
      DOM::isInvalidHtmlIdAttributeValue(attr, _) or
      // exclude attribute values that look like they might be templated
      attr.mayHaveTemplateValue()
    )
  )
}

/**
 * Holds if attributes `earlier` and `later` are id attributes with the same value in
 * the same document, and `earlier` appears textually before `later`.
 */
predicate sameId(DOM::AttributeDefinition earlier, DOM::AttributeDefinition later) {
  exists (string id, DOM::ElementDefinition root, int l1, int c1, int l2, int c2 |
    idAt(earlier, id, root, l1, c1) and idAt(later, id, root, l2, c2) |
    l1 < l2 or
    l1 = l2 and c1 < c2
  )
}

from DOM::AttributeDefinition earlier, DOM::AttributeDefinition later
where sameId(earlier, later) and not sameId(_, earlier)
select earlier, "This element has the same id as $@.", later, "another element"
