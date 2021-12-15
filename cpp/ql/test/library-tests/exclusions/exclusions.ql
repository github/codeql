import semmle.code.cpp.commons.Exclusions

from Element e
where isFromMacroDefinition(e)
select e
