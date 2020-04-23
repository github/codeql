import python
import semmle.python.web.bottle.General

from BottleRoute route
select route.getFunction(), route.getUrlPattern()
