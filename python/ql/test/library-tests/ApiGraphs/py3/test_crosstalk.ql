import python
import semmle.python.ApiGraphs

from API::CallNode callNode, string member
where
  callNode = API::moduleImport("foo").getMember(member).getACall() and
  callNode.getLocation().getFile().getBaseName() = "test_crosstalk.py"
select callNode, member
