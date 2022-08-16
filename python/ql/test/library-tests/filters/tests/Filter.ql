import python
import semmle.python.filters.Tests

from TestScope t
where exists(t.getLocation().getFile().getRelativePath())
select t
