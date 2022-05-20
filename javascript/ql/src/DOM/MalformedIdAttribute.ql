/**
 * @name Malformed id attribute
 * @description If the id of an HTML attribute is malformed, its
 *              interpretation may be browser-dependent.
 * @kind problem
 * @problem.severity warning
 * @id js/malformed-html-id
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-758
 * @precision very-high
 */

import javascript

from DOM::AttributeDefinition id, string reason
where
  DOM::isInvalidHtmlIdAttributeValue(id, reason) and
  // exclude attribute values that look like they might be templated
  not id.mayHaveTemplateValue()
select id, "The value of the id attribute " + reason + "."
