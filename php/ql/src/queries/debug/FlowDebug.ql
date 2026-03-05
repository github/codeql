/**
 * @name Flow debug - check header calls
 * @description Check header calls (for open redirect detection)
 * @kind problem
 * @problem.severity warning
 * @id php/debug/flow-debug
 */

import codeql.php.AST

from FunctionCallExpr call
where
  call.getFunctionName() = "header" and
  call.getLocation().getFile().getAbsolutePath().matches("%open_redirect%")
select call,
  "header() at " + call.getLocation().getFile().getBaseName() + " L" +
    call.getLocation().getStartLine() + " args=" + count(int i | exists(call.getArgument(i)))
