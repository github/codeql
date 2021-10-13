/**
 * @name Prefix or suffix predicate calls when comparing with literal
 * @description Using 'myString.prefix(n) = "..."' instead of 'myString.matches("...%")'
 * @kind problem
 * @problem.severity error
 * @id ql/prefix-or-suffix-equality-check
 * @tags performance
 * @precision high
 */

import ql
import codeql_ql.ast.internal.Predicate

class StringClass extends PrimitiveType {
  StringClass() { this.getName() = "string" }
}

class PrefixPredicate extends BuiltinPredicate {
  PrefixPredicate() { this = any(StringClass sc).getClassPredicate("prefix", 1) }
}

class SuffixPredicate extends BuiltinPredicate {
  SuffixPredicate() { this = any(StringClass sc).getClassPredicate("suffix", 1) }
}

class PrefixPredicateCall extends Call {
  PrefixPredicateCall() { this.getTarget() instanceof PrefixPredicate }
}

class SuffixPredicateCall extends Call {
  SuffixPredicateCall() { this.getTarget() instanceof SuffixPredicate }
}

class EqFormula extends ComparisonFormula {
  EqFormula() { this.getSymbol() = "=" }
}

pragma[inline]
string getMessage(Call call, String literal) {
  call instanceof PrefixPredicateCall and result = ".matches(\"" + literal.getValue() + "%\")"
  or
  call instanceof SuffixPredicateCall and result = ".matches(\"%" + literal.getValue() + "\")"
}

from EqFormula eq, PrefixPredicateCall call, String literal
where eq.getAnOperand() = call and eq.getAnOperand() = literal
select eq,
  "Use " + getMessage(call, literal) + " instead (but be sure to escape " + literal.getValue() +
    ")."
