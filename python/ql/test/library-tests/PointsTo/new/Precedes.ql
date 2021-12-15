import python
import Util

from Scope pre, Scope post
where pre.precedes(post)
select locate(pre.getLocation(), "q"), pre.toString(), locate(post.getLocation(), "q"),
  post.toString()
