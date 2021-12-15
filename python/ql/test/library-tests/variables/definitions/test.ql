import python

from DefinitionNode d
select d.getLocation().getStartLine(), d.getLocation().getStartColumn(), d.toString()
