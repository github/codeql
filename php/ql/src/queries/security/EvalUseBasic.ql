/**
 * @name Eval use (basic)
 * @description Finds calls to eval() in PHP code.
 * @kind problem
 * @problem.severity warning
 * @id php/eval-use-basic
 * @tags security
 */

import codeql.php.ast.internal.TreeSitter

from Php::FunctionCallExpression call, Php::AstNode fn
where
  fn = call.getFunction() and
  fn.(Php::Token).getValue() = "eval"
select call, "Avoid using eval()."
