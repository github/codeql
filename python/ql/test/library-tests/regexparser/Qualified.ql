import python
import semmle.python.RegexParserExtended

from Regex r, SuffixRegex sr, int start, int end, boolean maybe_empty
where
  r.isRoot() and
  r = sr.getParent*() and
  start = sr.getStartOffset() and
  end = sr.getEndOffset() and
  (
    sr.isMaybeEmpty() and maybe_empty = true
    or
    not sr.isMaybeEmpty() and maybe_empty = false
  )
select r.getText(), start, end, maybe_empty
