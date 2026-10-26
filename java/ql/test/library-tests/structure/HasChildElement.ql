import java

from Element e1, Element e2
where
  e1.hasChildElement(e2) and
  e1.getFile().toString() = "A"
select e1, e2
