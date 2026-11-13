import cpp

from VariableDeclarationEntry i
where not exists(i.getType())
select i
