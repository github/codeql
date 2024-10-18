/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id rus/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import codeql.IDEContextual
import codeql.rust.elements.Variable
import codeql.rust.elements.Locatable
import codeql.rust.elements.FormatArgsExpr
import codeql.rust.elements.FormatArgsArg
import codeql.rust.elements.NamedFormatArgument
import codeql.rust.elements.PositionalFormatArgument

external string selectedSourceFile();

newtype TDef =
  TVariable(Variable v) or
  TFormatArgsArgName(Name name) { name = any(FormatArgsArg a).getName() } or
  TFormatArgsArgIndex(Expr e) { e = any(FormatArgsArg a).getExpr() }

class Definition extends TDef {
  predicate hasLocationInfo(string file, int startLine, int startColumn, int endLine, int endColumn) {
    this.asVariable()
        .getLocation()
        .hasLocationInfo(file, startLine, startColumn, endLine, endColumn) or
    this.asName().hasLocationInfo(file, startLine, startColumn, endLine, endColumn) or
    this.asExpr().hasLocationInfo(file, startLine, startColumn, endLine, endColumn)
  }

  Variable asVariable() { this = TVariable(result) }

  Name asName() { this = TFormatArgsArgName(result) }

  Expr asExpr() { this = TFormatArgsArgIndex(result) }

  string toString() {
    result = this.asExpr().toString() or
    result = this.asVariable().toString() or
    result = this.asName().getText()
  }
}

predicate localVariable(AstNode e, Variable def) { e = def.getAnAccess() }

predicate namedFormatArgument(NamedFormatArgument e, Name def) {
  exists(FormatArgsExpr parent |
    parent = e.getParent().getParent() and
    parent.getAnArg().getName() = def and
    e.getName() = def.getText()
  )
}

predicate positionalFormatArgument(PositionalFormatArgument e, Expr def) {
  exists(FormatArgsExpr parent |
    parent = e.getParent().getParent() and
    def = parent.getArg(e.getIndex()).getExpr()
  )
}

from Locatable e, Definition def, string kind
where
  e.hasLocationInfo(getFileBySourceArchiveName(selectedSourceFile()).getAbsolutePath(), _, _, _, _) and
  (
    localVariable(e, def.asVariable()) and kind = "local variable"
    or
    namedFormatArgument(e, def.asName()) and kind = "format argument"
    or
    positionalFormatArgument(e, def.asExpr()) and kind = "format argument"
  )
select e, def, kind
