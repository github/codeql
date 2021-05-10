import python
import semmle.python.regex

from Regex r, int start, int end, boolean maybe_empty
where r.qualifiedItem(start, end, maybe_empty)
select r.getText(), start, end, maybe_empty
