/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped dot as part of the hostname might match more hostnames than expected.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import python
import semmle.python.regex

private string commonTopLevelDomainRegex() { result = "com|org|edu|gov|uk|net|io" }

/**
 * Holds if `pattern` is a regular expression pattern for URLs with a host matched by `hostPart`,
 * and `pattern` contains a subtle mistake that allows it to match unexpected hosts.
 */
bindingset[pattern]
predicate isIncompleteHostNameRegExpPattern(string pattern, string hostPart) {
  hostPart =
    pattern
        .regexpCapture("(?i).*" +
            // an unescaped single `.`
            "(?<!\\\\)[.]" +
            // immediately followed by a sequence of subdomains, perhaps with some regex characters mixed in, followed by a known TLD
            "([():|?a-z0-9-]+(\\\\)?[.](" + commonTopLevelDomainRegex() + "))" + ".*", 1)
}

from Regex r, string pattern, string hostPart
where
  r.getText() = pattern and
  isIncompleteHostNameRegExpPattern(pattern, hostPart) and
  // ignore patterns with capture groups after the TLD
  not pattern.regexpMatch("(?i).*[.](" + commonTopLevelDomainRegex() + ").*[(][?]:.*[)].*")
select r,
  "This regular expression has an unescaped '.' before '" + hostPart +
    "', so it might match more hosts than expected."
