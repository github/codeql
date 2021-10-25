import cpp

from NameQualifier nq, Location l
where
  l = nq.getQualifiedElement().getLocation() and
  l.getFile().getShortName() = "name_qualifiers"
select nq, nq.getQualifiedElement(), nq.getQualifyingElement()
