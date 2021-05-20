import python
import semmle.python.RegexParserExtended

from Regex r, GroupRegex gr, Regex part, int start, int end, int part_start, int part_end
where
  r.isRoot() and
  r = gr.getParent*() and
  start = gr.getStartOffset() and
  end = gr.getEndOffset() and
  part_start = part.getStartOffset() and
  part_end = part.getEndOffset() and
  part = gr.getContents()
select r.getText(), start, end, gr.getText(), part_start, part_end, part.getText()
