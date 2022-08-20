/**
 * @name File opened with O_CREAT flag but without mode argument
 * @description Opening a file with the O_CREAT flag but without mode argument reads arbitrary bytes from the stack.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/open-call-with-mode-argument
 * @tags security
 *       external/cwe/cwe-732
 */

import cpp
import FilePermissions

from FileCreationWithOptionalModeExpr fc
where not fc.hasModeArgument()
select fc,
  "A file is created here without providing a mode argument, which may leak bits from the stack."
