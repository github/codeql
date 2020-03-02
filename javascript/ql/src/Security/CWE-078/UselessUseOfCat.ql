/**
 * @name Unnecessary use of `cat` process
 * @description Using the  `cat` process to read a file is unnecessarily complex, inefficient, unportable, and can lead to subtle bugs, or even security vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/unnecessary-use-of-cat
 * @tags correctness
 *       security
 *       maintainability
 */

import javascript
import semmle.javascript.security.UselessUseOfCat
import semmle.javascript.RestrictedLocations

from UselessCat cat, string message
where
  message = " Can be replaced with: " + PrettyPrintCatCall::createReadFileCall(cat)
  or
  not exists(PrettyPrintCatCall::createReadFileCall(cat)) and
  if cat.isSync()
  then message = " Can be replaced with a call to fs.readFileSync(..)."
  else message = " Can be replaced with a call to fs.readFile(..)."
select cat.asExpr().(FirstLineOf), "Unnecessary use of `cat` process." + message
