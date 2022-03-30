import python

from ClassObject cls, string style
where
  not cls.isC() and
  not cls.failedInference() and
  (if cls.isNewStyle() then style = "new" else style = "old")
select cls.toString(), style
