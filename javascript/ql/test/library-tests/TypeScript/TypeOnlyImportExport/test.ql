import javascript

query VarRef getAVarReference(Variable v) {
    result = v.getAReference()
}

query VarRef getAnExportAccess(LocalTypeName t) {
    result = t.getAnExportAccess()
}

query TypeDecl getATypeDecl(LocalTypeName t) {
    result = t.getADeclaration()
}
