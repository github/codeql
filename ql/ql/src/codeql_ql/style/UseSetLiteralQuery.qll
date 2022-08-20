import ql

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
  Formula getOperand(int i) {
    result =
      rank[i + 1](Formula operand, Location l |
        operand = getAnOperand*() and
        not operand instanceof Disjunction and
        l = operand.getLocation()
      |
        operand order by l.getStartLine(), l.getStartColumn()
      )
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
    getOperator() = "=" and
    getAnOperand() instanceof Literal
  }

  AstNode getOther() {
    result = getAnOperand() and
    not result instanceof Literal
  }

  Literal getLiteral() { result = getAnOperand() }
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
  AstNode firstOperand;

  DisjunctionEqualsLiteral() {
    // VarAccess on the same variable
    exists(VarDef v |
      forex(Formula f | f = getOperand(_) |
        f.(EqualsLiteral).getAnOperand().(VarAccess).getDeclaration() = v
      ) and
      firstOperand = getOperand(0).(EqualsLiteral).getAnOperand() and
      firstOperand.(VarAccess).getDeclaration() = v
    )
    or
    // FieldAccess on the same variable
    exists(FieldDecl v |
      forex(Formula f | f = getOperand(_) |
        f.(EqualsLiteral).getAnOperand().(FieldAccess).getDeclaration() = v
      ) and
      firstOperand = getOperand(0).(EqualsLiteral).getAnOperand() and
      firstOperand.(FieldAccess).getDeclaration() = v
    )
    or
    // ThisAccess
    forex(Formula f | f = getOperand(_) | f.(EqualsLiteral).getAnOperand() instanceof ThisAccess) and
    firstOperand = getOperand(0).(EqualsLiteral).getAnOperand().(ThisAccess)
    or
    // ResultAccess
    forex(Formula f | f = getOperand(_) | f.(EqualsLiteral).getAnOperand() instanceof ResultAccess) and
    firstOperand = getOperand(0).(EqualsLiteral).getAnOperand().(ResultAccess)
    // (in principle something like GlobalValueNumbering could be used to generalize this)
  }

  /**
   * Gets the first "thing" that is the same thing in this chain of equalities.
   */
  AstNode getFirstOperand() { result = firstOperand }
}

/**
 * A call with a single `Literal` argument. For example:
 * ```
 * myPredicate(4)
 * ```
 */
class CallLiteral extends Call {
  CallLiteral() {
    getNumberOfArguments() = 1 and
    getArgument(0) instanceof Literal
  }
}

/**
 * A chain of disjunctions where each operand is a call to the same predicate
 * using various `Literal`s. For example:
 * ```
 * myPredicate(4) or
 * myPredicate(5) or
 * myPredicate(6)
 * ```
 */
class DisjunctionPredicateLiteral extends DisjunctionChain {
  DisjunctionPredicateLiteral() {
    // Call to the same target
    exists(PredicateOrBuiltin target |
      forex(Formula f | f = getOperand(_) | f.(CallLiteral).getTarget() = target)
    )
  }
}
