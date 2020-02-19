import javascript

from RegExpRange rr, string lb, string ub
where
  lb = rr.getLowerBound().toString() and
  if exists(rr.getUpperBound()) then ub = rr.getUpperBound().toString() else ub = "<none>"
select rr, lb, ub
