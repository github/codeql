/**
 * Incomplete URL substring sanitization
 */

private import IncompleteUrlSubstringSanitizationSpecific

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

/** Holds if there is an incomplete URL substring sanitization problem */
query predicate problems(
  SomeSubstringCheck check, string msg, DataFlow::Node substring, string target
) {
  substring = check.getSubstring() and
  mayHaveStringValue(substring, target) and
  (
    // target contains a domain on a common TLD, and perhaps some other URL components
    target
        .regexpMatch("(?i)([a-z]*:?//)?\\.?([a-z0-9-]+\\.)+" + RegExpPatterns::getACommonTld() +
            "(:[0-9]+)?/?")
    or
    // target is a HTTP URL to a domain on any TLD
    target.regexpMatch("(?i)https?://([a-z0-9-]+\\.)+([a-z]+)(:[0-9]+)?/?")
    or
    // target is a HTTP URL to a domain on any TLD with path elements, and the check is an includes check
    check instanceof StringOps::Includes and
    target.regexpMatch("(?i)https?://([a-z0-9-]+\\.)+([a-z]+)(:[0-9]+)?/[a-z0-9/_-]+")
  ) and
  (
    if check instanceof StringOps::StartsWith
    then msg = "'$@' may be followed by an arbitrary host name."
    else
      if check instanceof StringOps::EndsWith
      then msg = "'$@' may be preceded by an arbitrary host name."
      else msg = "'$@' can be anywhere in the URL, and arbitrary hosts may come before or after it."
  ) and
  // whitelist
  not (
    // the leading dot in a subdomain sequence makes the suffix-check safe (if it is performed on the host of the url)
    check instanceof StringOps::EndsWith and
    target.regexpMatch("(?i)\\.([a-z0-9-]+)(\\.[a-z0-9-]+)+")
    or
    // the trailing port or slash makes the prefix-check safe
    check instanceof StringOps::StartsWith and
    target.regexpMatch(".*(:[0-9]+|/)")
  )
}
