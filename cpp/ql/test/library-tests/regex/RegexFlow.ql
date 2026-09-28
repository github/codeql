/**
 * Tests for the `RegexFlowConfigs` library: `regexMatchedAgainst`,
 * `usedAsRegex`, flag detection, and grammar gating.
 */

import cpp
import semmle.code.cpp.regex.RegexFlowConfigs

query predicate usedAsRegex_(StringLiteral s) { usedAsRegex(s) }

query predicate regexMatchedAgainst_(StringLiteral regex, Expr subject) {
  regexMatchedAgainst(regex, subject)
}

query predicate hasIgnoreCaseFlag_(StringLiteral regex) { hasIgnoreCaseFlag(regex) }

query predicate hasMultilineFlag_(StringLiteral regex) { hasMultilineFlag(regex) }

query predicate hasNonEcmaScriptGrammarFlag_(StringLiteral regex) {
  hasNonEcmaScriptGrammarFlag(regex)
}
