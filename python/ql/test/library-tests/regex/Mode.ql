import python
import semmle.python.regex

from Regex r
where r.getLocation().getFile().getBaseName() = "test.py"
select r.getLocation().getStartLine(), r.getAMode()
