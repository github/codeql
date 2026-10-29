import semmle.code.cpp.commons.Dependency

from Element source, Element dest
where
  dependsOnSimple(source, dest) and
  source.getFile() != dest.getFile() and
  not source.isFromTemplateInstantiation(_)
select source, dest
