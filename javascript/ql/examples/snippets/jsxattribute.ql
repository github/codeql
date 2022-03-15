/**
 * @id js/examples/jsxattribute
 * @name JSX attributes
 * @description Finds JSX attributes named `dangerouslySetInnerHTML`
 * @tags JSX
 *       attribute
 */

import javascript

from JsxAttribute a
where a.getName() = "dangerouslySetInnerHTML"
select a
