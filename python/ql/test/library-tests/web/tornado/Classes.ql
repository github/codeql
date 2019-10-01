
import python

import semmle.python.TestUtils

import semmle.python.web.tornado.Tornado
from ClassObject cls
where cls = aTornadoRequestHandlerClass()
select cls.toString(), remove_library_prefix(cls.getPyClass().getLocation())
