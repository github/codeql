import python
import semmle.python.TestUtils
import semmle.python.web.twisted.Twisted

from FunctionObject func, string name
where func = getTwistedRequestHandlerMethod(name)
select name, func.toString(), remove_library_prefix(func.getFunction().getLocation())
