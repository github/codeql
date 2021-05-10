import python
import semmle.python.regex

from Regex r
select r.getLocation().getStartLine(), r.getAMode()
