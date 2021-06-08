import python

// as used in semmle.python.filters.Tests
from ClassValue c, string base
where
  c.getScope().getLocation().getFile().getShortName().matches("mwe%.py") and
  c.getName() = "MyTest" and
  if exists(c.getABaseType())
  then base = c.getABaseType().toString()
  else base = "<MISSING BASE TYPE>"
select c, base
