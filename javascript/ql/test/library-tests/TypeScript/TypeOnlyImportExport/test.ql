import javascript

query VarRef getAVarReference(Variable v) { result = v.getAReference() }

query VarRef getAnExportAccess(LocalTypeName t) { result = t.getAnExportAccess() }

query TypeDecl getATypeDecl(LocalTypeName t) { result = t.getADeclaration() }

query Function calls(DataFlow::InvokeNode invoke) { result = invoke.getACallee() }

query predicate exportsAs(ExportDeclaration exprt, LexicalName v, string name, string kind) {
  exprt.exportsAs(v, name) and
  kind = v.getDeclarationSpace()
}
