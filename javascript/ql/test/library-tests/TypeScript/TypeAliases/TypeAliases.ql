import javascript

from TypeAliasDeclaration decl
select decl, decl.getIdentifier(), decl.getNumTypeParameter(), decl.getDefinition()

query Type rightHandSide(TypeAliasDeclaration decl) { result = decl.getDefinition().getType() }

query Type getAliasedType(TypeAliasReference ref) { result = ref.getAliasedType() }

query Type getTypeArgument(TypeAliasReference ref, int n) { result = ref.getTypeArgument(n) }

query Type unfold(TypeAliasReference t) { result = t.unfold() }
