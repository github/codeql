import python
import semmle.python.filters.GeneratedCode

from GeneratedFile f, string tool
where
  tool = f.getTool()
  or
  not exists(f.getTool()) and tool = "none"
select f.toString(), tool
