/**
 * @name Useless use of cat
 * @description Using cat to simply read a file can lead to unintended bugs, and at worst security issues.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/useless-use-of-cat
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import semmle.javascript.security.UselessUseOfCat
import semmle.javascript.RestrictedLocations


from UselessCat cat
select cat.asExpr().(FirstLineOf), "Useless use of `cat`. Can be replaced with: " + createReadFileCall(cat)