import python
import semmle.python.regex

predicate part(Regex r, int start, int end, string kind) {
  r.alternation(start, end) and kind = "choice"
  or
  r.normalCharacter(start, end) and kind = "char"
  or
  r.escapedCharacter(start, end) and
  kind = "char" and
  not r.specialCharacter(start, end, _)
  or
  r.specialCharacter(start, end, kind)
  or
  r.sequence(start, end) and kind = "sequence"
  or
  r.charSet(start, end) and kind = "char-set"
  or
  r.zeroWidthMatch(start, end) and kind = "empty group"
  or
  r.group(start, end) and not r.zeroWidthMatch(start, end) and kind = "non-empty group"
  or
  r.qualifiedItem(start, end, _, _) and kind = "qualified"
}

from Regex r, int start, int end, string kind
where part(r, start, end, kind) and r.getLocation().getFile().getBaseName() = "test.py"
select r.getText(), kind, start, end
