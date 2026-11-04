import unified

from VariableDeclaration decl
where decl.getFile().getRelativePath() = "test.swift"
select decl.getPattern(), concat(decl.getValue().getStringValue())
