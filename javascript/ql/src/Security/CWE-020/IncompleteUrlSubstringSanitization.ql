/**
 * @name Incomplete URL substring sanitization
 * @description Security checks on the substrings of an unparsed URL are often vulnerable to bypassing.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/incomplete-url-substring-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import javascript
import DataFlow::PathGraph
import SmallStrings

/**
 * A node for a string value that looks like a URL. Used as a source
 * for incomplete URL substring checks.
 */
class UrlStringSource extends DataFlow::Node {
  string str;

  UrlStringSource() {
    isSmallString(this, str) and
    (
      // contains a domain on a common TLD, and perhaps some other URL components
      str
          .regexpMatch("(?i)([a-z]*:?//)?\\.?([a-z0-9-]+\\.)+" + RegExpPatterns::commonTLD() +
              "(:[0-9]+)?/?")
      or
      // is a HTTP URL to a domain on any TLD
      str.regexpMatch("(?i)https?://([a-z0-9-]+\\.)+([a-z]+)(:[0-9]+)?/?")
    )
  }

  /**
   * Gets the string value of this node.
   */
  string getString() { result = str }
}

/**
 * A check on a string for whether it contains a given substring, possibly with restrictions on the location of the substring.
 */
class SomeSubstringCheck extends DataFlow::Node {
  DataFlow::Node substring;

  SomeSubstringCheck() {
    this.(StringOps::StartsWith).getSubstring() = substring or
    this.(StringOps::Includes).getSubstring() = substring or
    this.(StringOps::EndsWith).getSubstring() = substring
  }

  /**
   * Gets the substring.
   */
  DataFlow::Node getSubstring() { result = substring }
}

/**
 * A taint tracking configuration for incomplete URL substring checks.
 */
class DomainUrlStringSubstringCheckConfiguration extends DataFlow::Configuration {
  DomainUrlStringSubstringCheckConfiguration() {
    this = "DomainUrlStringSubstringCheckConfiguration"
  }

  override predicate isSource(DataFlow::Node source) { source instanceof UrlStringSource }

  override predicate isSink(DataFlow::Node sink) { any(SomeSubstringCheck s).getSubstring() = sink }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(TaintTracking::AdditionalTaintStep dts).step(pred, succ)
  }

}

/**
 * Holds if `source` flows to `sink`, indicating a use of `substring`
 * in an incomplete URL substring checks, explained by `msg`.
 */
predicate isIncompleteSubstringCheck(
  DataFlow::PathNode source, DataFlow::PathNode sink, string substring, string msg
) {
  exists(DomainUrlStringSubstringCheckConfiguration cfg |
    cfg.hasFlowPath(source, sink) and
    substring = source.getNode().(UrlStringSource).getString()
  ) and
  exists(SomeSubstringCheck check | check.getSubstring() = sink.getNode() |
    (
      if check instanceof StringOps::StartsWith
      then msg = "may be followed by an arbitrary host name"
      else
        if check instanceof StringOps::EndsWith
        then msg = "may be preceded by an arbitrary host name"
        else msg = "can be anywhere in the URL, and arbitrary hosts may come before or after it"
    ) and
    // whitelist
    not (
      // the leading dot in a subdomain sequence makes the suffix-check safe (if it is performed on the host of the url)
      check instanceof StringOps::EndsWith and
      substring.regexpMatch("(?i)\\.([a-z0-9-]+)(\\.[a-z0-9-]+)+")
      or
      // the trailing port or slash makes the prefix-check safe
      check instanceof StringOps::StartsWith and
      substring.regexpMatch(".*(:[0-9]+|/)")
    )
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink, string sourceString, string msg
where isIncompleteSubstringCheck(source, sink, sourceString, msg)
select sink.getNode(), source, sink, "'$@' " + msg + ".", source.getNode(), sourceString
