/**
 * @name Incomplete URL substring sanitization
 * @description Security checks on the substrings of an unparsed URL are often vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id py/incomplete-url-substring-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import python
import semmle.python.regex

private string commonTopLevelDomainRegex() { result = "com|org|edu|gov|uk|net|io" }

predicate looksLikeUrl(StrConst s) {
  exists(string text | text = s.getText() |
    text
        .regexpMatch("(?i)([a-z]*:?//)?\\.?([a-z0-9-]+\\.)+(" + commonTopLevelDomainRegex() +
            ")(:[0-9]+)?/?")
    or
    // target is a HTTP URL to a domain on any TLD
    text.regexpMatch("(?i)https?://([a-z0-9-]+\\.)+([a-z]+)(:[0-9]+)?/?")
  )
}

predicate incomplete_sanitization(Expr sanitizer, StrConst url) {
  looksLikeUrl(url) and
  (
    sanitizer.(Compare).compares(url, any(In i), _)
    or
    unsafe_call_to_startswith(sanitizer, url)
    or
    unsafe_call_to_endswith(sanitizer, url)
  )
}

predicate unsafe_call_to_startswith(Call sanitizer, StrConst url) {
  sanitizer.getFunc().(Attribute).getName() = "startswith" and
  sanitizer.getArg(0) = url and
  not url.getText().regexpMatch("(?i)https?://[\\.a-z0-9-]+/.*")
}

predicate unsafe_call_to_endswith(Call sanitizer, StrConst url) {
  sanitizer.getFunc().(Attribute).getName() = "endswith" and
  sanitizer.getArg(0) = url and
  not url.getText().regexpMatch("(?i)\\.([a-z0-9-]+)(\\.[a-z0-9-]+)+")
}

from Expr sanitizer, StrConst url
where incomplete_sanitization(sanitizer, url)
select sanitizer, "'$@' may be at an arbitrary position in the sanitized URL.", url, url.getText()
