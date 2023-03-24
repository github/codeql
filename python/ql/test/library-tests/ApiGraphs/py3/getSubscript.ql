import python
import semmle.python.ApiGraphs

select API::moduleImport("mypkg").getMember("foo").getReturn().getSubscript(["bar", "baz", "qux"])
