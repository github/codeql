import python
import semmle.python.RegexParserExtended

predicate zeroWidthMatch(Regex r) {
  // missing empty grup here
  r instanceof ConfGroupRegex
  or
  r instanceof AssertionGroupRegex
}

predicate part(Regex r, int start, int end, string kind) {
  start = r.getStartOffset() and
  end = r.getEndOffset() and
  (
    r instanceof OrRegex and kind = "choice"
    or
    r instanceof ChRegex and kind = "char"
    or
    r instanceof EscapeClassRegex and kind = "char"
    or
    r instanceof ClassChar and kind = "char"
    or
    r instanceof SpecialCharRegex and kind = r.getText()
    or
    r instanceof SequenceRegex and
    kind = "sequence"
    or
    r instanceof ClassRegex and kind = "char-set"
    or
    zeroWidthMatch(r) and kind = "empty group"
    or
    r instanceof GroupRegex and not zeroWidthMatch(r) and kind = "non-empty group"
    or
    r instanceof SuffixRegex and kind = "qualified"
  )
}

from Regex r, Regex part, int start, int end, string kind
where
  part(part, start, end, kind) and // and r.hasLocationInfo("test.py", _, _, _, _)
  r.isRoot() and
  r = part.getParent*()
select r.getText(), kind, start, end
