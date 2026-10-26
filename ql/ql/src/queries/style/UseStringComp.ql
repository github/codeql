/**
 * @name Use of regexp to match a set of constant string
 * @description Comparing against constant strings instead of a regexp can improve performance
 * @kind problem
 * @problem.severity recommendation
 * @id ql/use-string-compare
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.ast.internal.Type

predicate problem(MemberCall call) {
  call.getBase().getType().getASuperType*().(PrimitiveType).getName() = "string" and
  (
    call.getMemberName() = "regexpMatch" and
    call.getNumberOfArguments() = 1 and
    call.getArgument(0).(String).getValue().regexpMatch("([a-zA-Z0-9]+\\|)*[a-zA-Z0-9]+")
    or
    exists(string reg | call.getMemberName() = "matches" |
      call.getNumberOfArguments() = 1 and
      reg = call.getArgument(0).(String).getValue() and
      not reg.regexpMatch(".*(%|_).*")
    )
  )
}

from AstNode node
where problem(node)
select node, "Use string comparison instead of regexp to compare against a constant set of string."
