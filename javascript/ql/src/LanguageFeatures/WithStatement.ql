/**
 * @name With statement
 * @description The 'with' statement has subtle semantics and should not be used.
 * @kind problem
 * @problem.severity warning
 * @id js/with-statement
 * @tags maintainability
 *       language-features
 * @precision very-high
 */

import javascript
import semmle.javascript.RestrictedLocations

from WithStmt ws
select ws.(FirstLineOf), "Do not use 'with'."
