import javascript

from TypeAliasDeclaration decl
select decl, decl.getIdentifier(), decl.getNumTypeParameter(), decl.getDefinition()

query Type rightHandSide(TypeAliasDeclaration decl) {
  result = decl.getDefinition().getType()
}
