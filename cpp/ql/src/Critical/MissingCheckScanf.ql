/**
 * @name TODO
 * @description TODO
 * @kind problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision TODO
 * @id cpp/missing-check-scanf
 * @tags TODO
 */

import cpp
import semmle.code.cpp.commons.Scanf

from ScanfFunction scanf, FunctionCall fc
where
    fc.getTarget() = scanf and
    fc instanceof ExprInVoidContext
select fc, "This is a call to scanf."
