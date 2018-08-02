/**
 * @name Use of for-in comprehension blocks
 * @description 'for'-'in' comprehension blocks are a Mozilla-specific language extension
 *              that is no longer supported.
 * @kind problem
 * @problem.severity error
 * @id js/for-in-comprehension
 * @tags portability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-758
 * @precision very-high
 */

import javascript

from ForInComprehensionBlock ficb
select ficb, "For-in comprehension blocks are a non-standard language feature."
