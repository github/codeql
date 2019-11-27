import python
import semmle.python.TestUtils
import semmle.python.web.twisted.Twisted

from ClassObject cls
where cls = aTwistedRequestHandlerClass()
select cls.toString(), remove_library_prefix(cls.getPyClass().getLocation())
