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
 * @precision low
 */

import javascript

/**
 * Holds if `attr` is an id attribute with value `id` of a DOM element
 * under document `root` at the given `line` and `column`.
 *
 * Furthermore, the id is required to be valid, and not look like a template.
 */
predicate idAt(
  DOM::AttributeDefinition attr, string id, DOM::ElementDefinition root, int line, int column
) {
  exists(DOM::ElementDefinition elt | attr = elt.getAttributeByName("id") |
    id = attr.getStringValue() and
    root = elt.getRoot() and
    elt.getLocation().hasLocationInfo(_, line, column, _, _) and
    // exclude invalid ids (reported by another query)
    not DOM::isInvalidHtmlIdAttributeValue(attr, _)
  )
}

/**
 * Holds if attributes `earlier` and `later` are id attributes with the same value in
 * the same document, and `earlier` appears textually before `later`.
 */
predicate sameId(
  DOM::ElementDefinition root, DOM::AttributeDefinition earlier, DOM::AttributeDefinition later
) {
  exists(string id, int l1, int c1, int l2, int c2 |
    idAt(earlier, id, root, l1, c1) and idAt(later, id, root, l2, c2)
  |
    l1 < l2
    or
    l1 = l2 and c1 < c2
  )
}

/**
 * Holds if any attribute value in `root` looks like it is templated.
 */
predicate mayContainTemplates(DOM::ElementDefinition root) {
  exists(DOM::AttributeDefinition attr |
    attr.mayHaveTemplateValue() and
    root = attr.getElement().getRoot()
  )
}

from DOM::ElementDefinition root, DOM::AttributeDefinition earlier, DOM::AttributeDefinition later
where
  sameId(root, earlier, later) and
  // only flag the first ambiguity if there are many
  not sameId(root, _, earlier) and
  // exclude templates
  not mayContainTemplates(root)
select earlier, "This element has the same id as $@.", later, "another element"
