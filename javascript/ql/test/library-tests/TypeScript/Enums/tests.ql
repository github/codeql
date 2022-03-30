import javascript

query predicate analysis(VarAccess access, string types) {
  access.getVariable().getScope() instanceof EnumScope and
  types = access.analyze().ppTypes()
}

query predicate enums(
  EnumDeclaration enum, int n, string constness, string ambience, string exportedness,
  Identifier identifier, int numMember, EnumMember member
) {
  (if enum.isConst() then constness = "const" else constness = "") and
  (if enum.isAmbient() then ambience = "ambient" else ambience = "") and
  (
    if exists(ExportNamedDeclaration ed | enum = ed.getOperand())
    then exportedness = "exported"
    else exportedness = ""
  ) and
  identifier = enum.getIdentifier() and
  numMember = enum.getNumMember() and
  member = enum.getMember(n)
}

query predicate memberAccess(VarAccess access, EnumMember member) {
  access.getVariable().getADeclaration() = member.getIdentifier()
}

query predicate namesspaceAccess(
  EnumDeclaration enum, LocalNamespaceAccess access, Stmt enclosingStmt
) {
  access = enum.getLocalNamespaceName().getAnAccess() and
  enclosingStmt = access.getEnclosingStmt()
}

query predicate reachability(ExprOrStmt node) {
  node.(ControlFlowNode).isUnreachable() and not node.isAmbient()
}

query predicate typeAccess(EnumDeclaration enum, LocalTypeAccess access, Stmt enclosingStmt) {
  access = enum.getLocalTypeName().getAnAccess() and
  enclosingStmt = access.getEnclosingStmt()
}

query predicate variableAccess(EnumDeclaration enum, VarAccess access, Stmt enclosingStmt) {
  access = enum.getVariable().getAnAccess() and
  enclosingStmt = access.getEnclosingStmt()
}
