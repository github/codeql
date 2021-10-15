import python
import semmle.python.regex

from Regex r, int start, int end, int part_start, int part_end
where
  r.getLocation().getFile().getBaseName() = "test.py" and
  r.alternationOption(start, end, part_start, part_end)
select r.getText(), start, end, r.getText().substring(start, end), part_start, part_end,
  r.getText().substring(part_start, part_end)
