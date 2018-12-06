/**
 * @name Incomplete URL regular expression
 * @description Using a regular expression that contains an 'any character' may match more URLs than expected.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/incomplete-url-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import javascript
import semmle.javascript.security.dataflow.RegExpInjection

module IncompleteUrlRegExpTracking {

  /**
   * A taint tracking configuration for incomplete URL regular expressions sources.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "IncompleteUrlRegExpTracking" }

    override
    predicate isSource(DataFlow::Node source) {
      isIncompleteHostNameRegExpPattern(source.asExpr().getStringValue(), _)
    }

    override
    predicate isSink(DataFlow::Node sink) {
      sink instanceof RegExpInjection::Sink
    }

  }

}

/**
 * Holds if `pattern` is a regular expression pattern for URLs with a host matched by `hostPart`,
 * and `pattern` contains a subtle mistake that allows it to match unexpected hosts.
 */
bindingset[pattern]
predicate isIncompleteHostNameRegExpPattern(string pattern, string hostPart) {
  hostPart = pattern.regexpCapture(
    "(?i).*" +
    // an unescaped single `.`
    "(?<!\\\\)[.]" +
    // immediately followed by a sequence of subdomains, perhaps with some regex characters mixed in, followed by a known TLD
    "([():|?a-z0-9-]+(\\\\)?[.](com|org|edu|gov|uk|net))" +
    ".*", 1)
}

from Expr e, string pattern, string hostPart
where
      (
        e.(RegExpLiteral).getValue() = pattern or
        exists (IncompleteUrlRegExpTracking::Configuration cfg |
          cfg.hasFlow(e.flow(), _) and
          e.mayHaveStringValue(pattern)
        )
      ) and
      isIncompleteHostNameRegExpPattern(pattern, hostPart)
      and
      // ignore patterns with capture groups after the TLD
      not pattern.regexpMatch("(?i).*[.](com|org|edu|gov|uk|net).*[(][?]:.*[)].*")


select e, "This regular expression has an unescaped '.' before '" + hostPart + "', so it might match more hosts than expected."
