/**
 * @name Unused parameter.
 * @description A parameter that is not used later on, or whose value is always overwritten,
 *              can be removed.
 * @kind problem
 * @problem.severity warning
 * @id rb/unused-parameter
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision low
 */

import ruby
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
where not exists(Ssa::WriteDefinition def | def.getWriteAccess() = v.getDefiningAccess())
select v, "Unused parameter."
