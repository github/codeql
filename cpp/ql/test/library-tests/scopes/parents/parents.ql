import cpp

from Element parent, Element child
where parent = child.getParentScope()
select count(parent.getParentScope()), // For sensible output ordering
  parent, child
