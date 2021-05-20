import python
import semmle.python.RegexParserExtended

from Regex r, OrRegex orr, Regex part, int start, int end, int part_start, int part_end
where
  r.isRoot() and
  r = orr.getParent*() and
  start = orr.getStartOffset() and
  end = orr.getEndOffset() and
  part in [orr.getLeft(), orr.getRight()] and
  part_start = part.getStartOffset() and
  part_end = part.getEndOffset()
select r.getText(), start, end, orr.getText(), part_start, part_end, part.getText()
