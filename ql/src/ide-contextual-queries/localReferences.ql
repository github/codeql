/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id ql/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import ql
import codeql_ql.ast.internal.Module
import codeql.IDEContextual

external string selectedSourceFile();

newtype TLoc =
  TAst(AstNode n) or
  TFileOrModule(FileOrModule m)

class Loc extends TLoc {
  string toString() { result = "" }

  AstNode asAst() { this = TAst(result) }

  FileOrModule asMod() { this = TFileOrModule(result) }

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

predicate resolveModule(ModuleRef ref, FileOrModule target, string kind) {
  target = ref.getResolvedModule() and
  kind = "module" and
  ref.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
}

predicate resolveType(TypeExpr ref, AstNode target, string kind) {
  target = ref.getResolvedType().getDeclaration() and
  kind = "type" and
  ref.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
}

predicate resolve(Loc ref, Loc target, string kind) {
  resolveModule(ref.asAst(), target.asMod(), kind)
  or
  resolveType(ref.asAst(), target.asAst(), kind)
}

from Loc ref, Loc target, string kind
where resolve(ref, target, kind)
select ref, target, kind
