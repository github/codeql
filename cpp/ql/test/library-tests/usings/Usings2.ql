import cpp

from UsingEntry ue, Element e
where
  e = ue.getEnclosingElement()
select ue, e
