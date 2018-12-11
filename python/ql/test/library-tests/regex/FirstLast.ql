

import python
import semmle.python.regex

predicate part(Regex r, int start, int end, string kind) {
    r.lastItem(start, end) and kind = "last" 
    or
    r.firstItem(start, end) and kind = "first"
}

from Regex r, int start, int end, string kind
where part(r, start, end, kind)
select r.getText(), kind, start, end
