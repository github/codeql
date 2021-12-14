import ql
import codeql_ql.ast.internal.Predicate
import codeql_ql.ast.internal.Builtins

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
  EqFormula() { this.getOperator() = "=" }
}

bindingset[s]
string escape(string s) { result = s.replaceAll("_", "\\\\_").replaceAll("%", "\\\\%") }

pragma[inline]
string getMessage(FixPredicateCall call, String literal) {
  call instanceof PrefixPredicateCall and
  result = ".matches(\"" + escape(literal.getValue()) + "%\")"
  or
  call instanceof SuffixPredicateCall and
  result = ".matches(\"%" + escape(literal.getValue()) + "\")"
}

class FixPredicateCall extends Call {
  FixPredicateCall() { this instanceof PrefixPredicateCall or this instanceof SuffixPredicateCall }
}

class RegexpMatchPredicate extends BuiltinPredicate {
  RegexpMatchPredicate() { this = any(StringClass sc).getClassPredicate("regexpMatch", 1) }
}

predicate canUseMatchInsteadOfRegexpMatch(Call c, string matchesStr) {
  c.getTarget() instanceof RegexpMatchPredicate and
  exists(string raw | raw = c.getArgument(0).(String).getValue() |
    matchesStr = "%" + raw.regexpCapture("^\\.\\*([a-zA-Z\\d\\s-]+)$", _)
    or
    matchesStr = raw.regexpCapture("^([a-zA-Z\\d\\s-]+)\\.\\*$", _) + "%"
    or
    matchesStr = "%" + raw.regexpCapture("^\\.\\*([a-zA-Z\\d\\s-]+)\\.\\*$", _) + "%"
  )
}
