
import python
import semmle.python.filters.GeneratedCode

from GeneratedFile f
select f.toString(), f.getTool()
