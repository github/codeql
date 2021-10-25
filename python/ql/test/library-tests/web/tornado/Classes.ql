import python
import semmle.python.TestUtils
import semmle.python.web.tornado.Tornado

from ClassValue cls
where cls = aTornadoRequestHandlerClass()
select remove_library_prefix(cls.getScope().getLocation()), cls.toString()
