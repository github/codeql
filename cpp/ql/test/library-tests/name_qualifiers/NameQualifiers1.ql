import cpp

from NameQualifier nq, Location l
where l = nq.getQualifiedElement().getLocation()
select nq, nq.getQualifiedElement(), nq.getQualifyingElement()
