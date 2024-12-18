/**
 * @name Use of string after lifetime ends
 * @description If the value of a call to 'c_str' outlives the underlying object it may lead to unexpected behavior.
 * @kind problem
 * @precision high
 * @id cpp/use-of-string-after-lifetime-ends
 * @problem.severity warning
 * @security-severity 8.8
 * @tags reliability
 *       security
 *       external/cwe/cwe-416
 *       external/cwe/cwe-664
 */

import cpp
import semmle.code.cpp.models.implementations.StdString
import Temporaries

from Call c
where
  outlivesFullExpr(c) and
  not c.isFromUninstantiatedTemplate(_) and
  (c.getTarget() instanceof StdStringCStr or c.getTarget() instanceof StdStringData) and
  isTemporary(c.getQualifier().getFullyConverted())
select c,
  "The underlying temporary string object is destroyed after the call to '" + c.getTarget() +
    "' returns."
