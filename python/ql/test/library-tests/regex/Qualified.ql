import python
import semmle.python.regex

from Regex r, int start, int end, boolean maybe_empty, boolean may_repeat_forever
where r.qualifiedItem(start, end, maybe_empty, may_repeat_forever)
select r.getText(), start, end, maybe_empty, may_repeat_forever
