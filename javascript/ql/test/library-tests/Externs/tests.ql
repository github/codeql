import javascript

query predicate externalDecl_getName(ExternalDecl ed, string name) { name = ed.getName() }

query predicate externalDecl_getQualifiedName(ExternalDecl ed, string name) {
  name = ed.getQualifiedName()
}

query predicate externalDecl(ExternalDecl decl) { any() }

query predicate externalTypedef(ExternalTypedef typ) { any() }

query predicate externalVarDecl_getInit(ExternalVarDecl decl, AstNode init) {
  decl.getInit() = init
}

query predicate sourceDecl(ExternalVarDecl v, ExternalType typeDecl, string qname) {
  qname = v.getQualifiedName() and typeDecl = v.getTypeTag().getTypeDeclaration()
}
