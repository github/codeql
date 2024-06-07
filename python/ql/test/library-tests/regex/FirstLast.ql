import python
import semmle.python.regex

predicate part(RegExp r, int start, int end, string kind) {
  r.lastItem(start, end) and kind = "last"
  or
  r.firstItem(start, end) and kind = "first"
}

from RegExp r, int start, int end, string kind
where part(r, start, end, kind) and r.getLocation().getFile().getBaseName() = "test.py"
select r.getText(), kind, start, end
