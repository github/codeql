import python

from ClassObject cls, string reason
where
  cls.getPyClass().getEnclosingModule().getName() = "test" and
  cls.failedInference(reason)
select cls, reason
