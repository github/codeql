import ql
import codeql_ql.ast.internal.Module
import codeql.IDEContextual

private newtype TLoc =
  TAst(AstNode n) or
  TFileOrModule(FileOrModule m)

class Loc extends TLoc {
  string toString() { result = "" }

  AstNode asAst() { this = TAst(result) }

  FileOrModule asMod() { this = TFileOrModule(result) }

  File getFile() { this.hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    exists(AstNode n | this = TAst(n) |
      n.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
    or
    exists(FileOrModule m | this = TFileOrModule(m) |
      m.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
  }
}

private predicate resolveModule(ModuleRef ref, FileOrModule target, string kind) {
  target = ref.getResolvedModule() and
  kind = "module"
}

private predicate resolveType(TypeExpr ref, AstNode target, string kind) {
  target = ref.getResolvedType().getDeclaration() and
  kind = "type"
}

private predicate resolvePredicate(PredicateExpr ref, Predicate target, string kind) {
  target = ref.getResolvedPredicate() and
  kind = "predicate"
}

private predicate resolveVar(VarAccess va, VarDecl decl, string kind) {
  decl = va.getDeclaration() and
  kind = "variable"
}

private predicate resolveField(FieldAccess va, FieldDecl decl, string kind) {
  decl = va.getDeclaration() and
  kind = "field"
}

private predicate resolveCall(Call c, Predicate p, string kind) {
  p = c.getTarget() and
  kind = "call"
}

cached
predicate resolve(Loc ref, Loc target, string kind) {
  resolveModule(ref.asAst(), target.asMod(), kind)
  or
  resolveType(ref.asAst(), target.asAst(), kind)
  or
  resolvePredicate(ref.asAst(), target.asAst(), kind)
  or
  resolveField(ref.asAst(), target.asAst(), kind)
  or
  resolveVar(ref.asAst(), target.asAst(), kind)
  or
  resolveCall(ref.asAst(), target.asAst(), kind)
}
