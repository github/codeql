/**
 * @name Conditional comments
 * @description Conditional comments are an IE-specific feature and not portable.
 * @kind problem
 * @problem.severity warning
 * @id js/conditional-comment
 * @tags portability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-758
 * @precision very-high
 */

import javascript

from Comment c
where c.getText().trim().matches("@cc\\_on%")
select c, "Do not use conditional comments."
