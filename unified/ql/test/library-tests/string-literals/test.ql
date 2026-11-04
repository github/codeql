import unified

from VariableDeclaration decl
where decl.getFile().fromSource()
select decl.getPattern(), concat(decl.getValue().getStringValue())
