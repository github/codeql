import cpp

from Function f, string call
where
  if exists(f.getACallToThisFunction())
  then
    call =
      f.getACallToThisFunction().getLocation().toString() + " " +
        f.getACallToThisFunction().toString()
  else call = "<none>"
select f, f.getType(), call
