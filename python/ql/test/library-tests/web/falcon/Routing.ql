import python
import semmle.python.web.falcon.General

from FalconRoute route, string method
select route.getUrl(), method, route.getHandlerFunction(method)
