import python
import semmle.python.regex

from Regex r, int start, int end, boolean maybe_empty
where
  r.qualifiedItem(start, end, maybe_empty) and r.getLocation().getFile().getShortName() = "test.py"
select r.getText(), start, end, maybe_empty
