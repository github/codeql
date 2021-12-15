import python

from ClassObject cls, string legal
where
  not cls.isC() and cls.isLegalExceptionType() and legal = "yes" and not cls.failedInference()
  or
  not cls.isC() and not cls.isLegalExceptionType() and legal = "no" and not cls.failedInference()
  or
  not cls.isC() and cls.failedInference(legal)
select cls.toString(), legal
