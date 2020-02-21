/**
 * @name Useless use of cat
 * @description Using `cat`-process to simply read a file is unnecessarily complex, inefficient, unportable, can lead to subtle bugs, or even security vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/useless-use-of-cat
 * @tags correctness
 *       security
 *       maintainability
 */

import javascript
import semmle.javascript.security.UselessUseOfCat
import semmle.javascript.RestrictedLocations


from UselessCat cat
select cat.asExpr().(FirstLineOf), "Useless use of `cat`. Can be replaced with: " + createReadFileCall(cat)