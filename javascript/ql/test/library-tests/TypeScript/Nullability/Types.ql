import javascript

query Type exprType(Expr e) { result = e.getType() }

query Type unaliasedType(TypeAliasReference ref) { result = ref.getAliasedType() }
