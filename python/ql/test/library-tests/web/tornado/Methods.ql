
import python

import semmle.python.TestUtils

import semmle.python.web.tornado.Tornado

from FunctionObject func, string name
where func = getTornadoRequestHandlerMethod(name) and
/* Compatibility hack to make tests pass on both 1.20 and 1.21 */
not name = "_execute"
select name, func.toString(), remove_library_prefix(func.getFunction().getLocation())
