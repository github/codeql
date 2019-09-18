/**
 * @name Use of HTML comments
 * @description HTML-style comments are not a standard ECMAScript feature and should be avoided.
 * @kind problem
 * @problem.severity recommendation
 * @id js/html-comment
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-758
 * @precision low
 * @deprecated HTML comments are recognized in the standard as an additional feature supported by
 *             web browsers. Deprecated since 1.17.
 */

import javascript

from HtmlLineComment c
select c, "Do not use HTML comments."
