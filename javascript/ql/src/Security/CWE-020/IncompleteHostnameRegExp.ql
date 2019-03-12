/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped dot as part of the hostname might match more hostnames than expected.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import javascript
import SmallStrings

/**
 * A taint tracking configuration for incomplete hostname regular expressions sources.
 */
class Configuration extends DataFlow::Configuration {
  Configuration() { this = "IncompleteHostnameRegExpTracking" }

  override predicate isSource(DataFlow::Node source) {
    exists (string pattern |
      isSmallRegExpPattern(source, pattern) and
      isIncompleteHostNameRegExpPattern(pattern, _)
    )
  }

  override predicate isSink(DataFlow::Node sink) { isInterpretedAsRegExp(sink) }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(TaintTracking::AdditionalTaintStep dts).step(pred, succ)
  }

}

/**
 * Holds if `pattern` is a regular expression pattern for URLs with a host matched by `hostPart`,
 * and `pattern` contains a subtle mistake that allows it to match unexpected hosts.
 */
bindingset[pattern]
predicate isIncompleteHostNameRegExpPattern(string pattern, string hostPart) {
  hostPart = pattern
        .regexpCapture("(?i).*" +
            // an unescaped single `.`
            "(?<!\\\\)[.]" +
            // immediately followed by a sequence of subdomains, perhaps with some regex characters mixed in, followed by a known TLD
            "([():|?a-z0-9-]+(\\\\)?[.]" + RegExpPatterns::commonTLD() + ")" + ".*", 1)
}

from DataFlow::Node e, string pattern, string hostPart
where
  isSmallRegExpPattern(e, pattern) and
  (
    e.asExpr() instanceof RegExpLiteral
    or
    exists(Configuration cfg |
      cfg.hasFlow(e, _) and
      e.mayHaveStringValue(pattern)
    )
  ) and
  isIncompleteHostNameRegExpPattern(pattern, hostPart) and
  // ignore patterns with capture groups after the TLD
  not pattern.regexpMatch("(?i).*[.]" + RegExpPatterns::commonTLD() + ".*[(][?]:.*[)].*")
select e,
  "This regular expression has an unescaped '.' before '" + hostPart +
    "', so it might match more hosts than expected."
