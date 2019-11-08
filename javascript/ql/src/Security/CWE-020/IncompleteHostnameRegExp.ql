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
import semmle.javascript.CharacterEscapes

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

from RegExpPatternSource re, string pattern, string hostPart, string kind, DataFlow::Node aux
where
  pattern = re.getPattern() and
  isIncompleteHostNameRegExpPattern(pattern, hostPart) and
  (
    if re.getAParse() != re
    then (
      kind = "string, which is used as a regular expression $@," and
      aux = re.getAParse()
    ) else (
      kind = "regular expression" and aux = re
    )
  ) and
  // ignore patterns with capture groups after the TLD
  not pattern.regexpMatch("(?i).*[.](" + RegExpPatterns::commonTLD() + ").*[(][?]:.*[)].*") and
  // avoid double reporting
  not CharacterEscapes::hasALikelyRegExpPatternMistake(re)
select re,
  "This " + kind + " has an unescaped '.' before '" + hostPart +
    "', so it might match more hosts than expected.", aux, "here"
