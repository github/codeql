import javascript

from FieldDeclaration decl
where decl.isOptional()
select decl.getStartLine().getText()
