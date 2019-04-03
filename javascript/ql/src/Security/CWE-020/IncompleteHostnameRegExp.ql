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

/**
 * Gets a node whose value may flow (inter-procedurally) to a position where it is interpreted
 * as a regular expression.
 */
DataFlow::Node regExpSource(DataFlow::Node re, DataFlow::TypeBackTracker t) {
  t.start() and
  re = result and
  isInterpretedAsRegExp(result)
  or
  exists(DataFlow::TypeBackTracker t2, DataFlow::Node succ | succ = regExpSource(re, t2) |
    t2 = t.smallstep(result, succ)
    or
    any(TaintTracking::AdditionalTaintStep dts).step(result, succ) and
    t = t2
  )
}

DataFlow::Node regExpSource(DataFlow::Node re) {
  result = regExpSource(re, DataFlow::TypeBackTracker::end())
}

/** Holds if `re` is a regular expression with value `pattern`. */
predicate regexp(DataFlow::Node re, string pattern, string kind, DataFlow::Node aux) {
  re.asExpr().(RegExpLiteral).getValue() = pattern and
  kind = "regular expression" and
  aux = re
  or
  re = regExpSource(aux) and
  pattern = re.getStringValue() and
  kind = "string, which is used as a regular expression $@,"
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

from DataFlow::Node re, string pattern, string hostPart, string kind, DataFlow::Node aux
where regexp(re, pattern, kind, aux) and
  isIncompleteHostNameRegExpPattern(pattern, hostPart) and
  // ignore patterns with capture groups after the TLD
  not pattern.regexpMatch("(?i).*[.](" + RegExpPatterns::commonTLD() + ").*[(][?]:.*[)].*")
select re,
  "This " + kind + " has an unescaped '.' before '" + hostPart +
    "', so it might match more hosts than expected.", aux, "here"