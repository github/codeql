import cpp
import semmle.code.cpp.Print

from Function f, string deleted, string defaulted
where
  (if f.isDeleted() then deleted = "deleted" else deleted = "") and
  if f.isDefaulted() then defaulted = "defaulted" else defaulted = ""
select f, getIdentityString(f), deleted, defaulted
