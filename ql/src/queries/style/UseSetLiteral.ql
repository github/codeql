/**
 * @name Use a set literal in place of `or`
 * @description A chain of `or`s can be replaced with a set literal, improving readability.
 * @kind problem
 * @problem.severity recommendation
 * @id ql/use-set-literal
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.ast.internal.Predicate // TODO: for PredicateOrBuiltin

/**
 * A chain of disjunctions treated as one object. For example the following is
 * a chain of disjunctions with three operands:
 * ```
 * a or b or c
 * ```
 */
class DisjunctionChain extends Disjunction {
  DisjunctionChain() { not exists(Disjunction parent | parent.getAnOperand() = this) }

  /**
   * Gets any operand of the chain.
   */
  Formula getAnOperandRec() {
    result = getAnOperand*() and
    not result instanceof Disjunction
  }
}

/**
 * An equality comparison with a `Literal`. For example:
 * ```
 * x = 4
 * ```
 */
class EqualsLiteral extends ComparisonFormula {
  EqualsLiteral() {
    getSymbol() = "=" and
    getAnOperand() instanceof Literal
  }
}

/**
 * A chain of disjunctions where each operand is an equality comparison between
 * the same thing and various `Literal`s. For example:
 * ```
 * x = 4 or
 * x = 5 or
 * x = 6
 * ```
 */
class DisjunctionEqualsLiteral extends DisjunctionChain {
  DisjunctionEqualsLiteral() {
    // VarAccess on the same variable
    exists(VarDef v |
      forex(Formula f | f = getAnOperandRec() |
        f.(EqualsLiteral).getAnOperand().(VarAccess).getDeclaration() = v
      )
    )
    or
    // FieldAccess on the same variable
    exists(VarDecl v |
      forex(Formula f | f = getAnOperandRec() |
        f.(EqualsLiteral).getAnOperand().(FieldAccess).getDeclaration() = v
      )
    )
    or
    // ThisAccess
    forex(Formula f | f = getAnOperandRec() |
      f.(EqualsLiteral).getAnOperand() instanceof ThisAccess
    )
    or
    // ResultAccess
    forex(Formula f | f = getAnOperandRec() |
      f.(EqualsLiteral).getAnOperand() instanceof ResultAccess
    )
    // (in principle something like GlobalValueNumbering could be used to generalize this)
  }
}

from DisjunctionChain d, int c
where
  d instanceof DisjunctionEqualsLiteral and
  c = count(d.getAnOperandRec()) and
  c >= 4
select d, "This formula can be replaced with equality on a set literal, improving readability."
