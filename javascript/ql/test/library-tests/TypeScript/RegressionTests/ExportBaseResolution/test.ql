import javascript

from LexicalName name, LexicalDecl decl, LexicalAccess access
where decl.getALexicalName() = name and access.getALexicalName() = name
select name.getName(), name.getDeclarationSpace(), decl, access
