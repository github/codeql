private import swift

private Decl getAMember(IterableDeclContext ctx) {
  ctx.getAMember() = result
  or
  exists(VarDecl var |
    ctx.getAMember() = var and
    var.getAnAccessorDecl() = result
  )
}

class MethodDecl extends AbstractFunctionDecl {
  MethodDecl() {
    this = getAMember(any(ClassDecl c))
    or
    this = getAMember(any(StructDecl c))
    or
    this = getAMember(any(ExtensionDecl c))
    or
    this = getAMember(any(EnumDecl c))
    or
    this = getAMember(any(ProtocolDecl c))
  }
}
