
import python

import semmle.python.TestUtils

import semmle.python.web.tornado.Tornado
from ClassValue cls
where cls = aTornadoRequestHandlerClass()
select cls.toString(), remove_library_prefix(cls.getScope().getLocation())
