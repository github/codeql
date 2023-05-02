import javascript

// The extractor would hang on this test case, it doesn't matter too much what the output of the test is.
query TypeAliasDeclaration typeAliases() { any() }

query Type typeAliasType(TypeAliasDeclaration decl) { result = decl.getTypeName().getType() }

query Type getAliasedType(TypeAliasReference ref) { result = ref.getAliasedType() }
