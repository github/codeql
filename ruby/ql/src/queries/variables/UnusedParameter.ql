/**
 * @name Unused parameter.
 * @description A parameter that is not used later on, or whose value is always overwritten,
 *              can be removed.
 * @kind problem
 * @problem.severity warning
 * @id rb/unused-parameter
 * @tags maintainability
 *       external/cwe/cwe-563
 *       quality
 * @precision low
 */

import codeql.ruby.AST
import codeql.ruby.dataflow.SSA

class RelevantParameterVariable extends LocalVariable {
  RelevantParameterVariable() {
    exists(Parameter p |
      this = p.getAVariable() and
      not this.getName().charAt(0) = "_"
    )
  }
}

from RelevantParameterVariable v
where
  not exists(Ssa::WriteDefinition def | def.getWriteAccess().getAstNode() = v.getDefiningAccess()) and
  not exists(SuperCall s | s.getEnclosingCallable().getAParameter().getAVariable() = v |
    // a call to 'super' without any arguments will pass on the parameter.
    not exists(s.getAnArgument())
  )
select v, "The parameter '" + v.getName() + "' is never used."
