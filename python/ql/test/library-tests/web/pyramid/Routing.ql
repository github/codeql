import python
import semmle.python.web.pyramid.View

from Function func
where is_pyramid_view_function(func)
select func.getLocation().toString(), func.toString()
