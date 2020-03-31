import python
import semmle.python.web.bottle.General

from BottleRoute route
select route.getUrl(), route.getFunction()
