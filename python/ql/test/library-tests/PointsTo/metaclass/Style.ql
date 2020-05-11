import python

from ClassObject cls, string style
where
  cls.getPyClass().getEnclosingModule().getName() = "test" and
  (
    cls.isNewStyle() and style = "new"
    or
    cls.isOldStyle() and style = "old"
  )
select cls, style
