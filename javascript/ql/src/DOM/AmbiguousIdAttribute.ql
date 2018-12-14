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
 * Holds if `elt` defines a DOM element with the given `id`
 * under document `root` at the given `line` and `column`.
 *
 * Furthermore, the id is required to be valid, and not look like a template.
 */
predicate elementAt(DOM::ElementDefinition elt, string id, DOM::ElementDefinition root, int line, int column) {
  exists (DOM::AttributeDefinition attr |
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
 * Holds if elements `earlier` and `later` have the same id and belong
 * to the same document, and `earlier` appears textually before `later`.
 */
predicate sameId(DOM::ElementDefinition earlier, DOM::ElementDefinition later) {
  exists (string id, DOM::ElementDefinition root, int l1, int c1, int l2, int c2 |
    elementAt(earlier, id, root, l1, c1) and elementAt(later, id, root, l2, c2) |
    l1 < l2 or
    l1 = l2 and c1 < c2
  )
}

from DOM::ElementDefinition earlier, DOM::ElementDefinition later
where sameId(earlier, later) and not sameId(_, earlier)
select earlier, "This element has the same id as $@.", later, "another element"
