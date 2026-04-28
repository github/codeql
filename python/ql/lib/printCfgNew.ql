/**
 * @name Print CFG (New)
 * @description Produces a representation of a file's Control Flow Graph
 *              using the new shared control flow library.
 *              This query is used by the VS Code extension.
 * @id python/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

private import python as Py
import semmle.python.controlflow.internal.AstNodeImpl

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewCfgQueryInput implements ControlFlow::ViewCfgQueryInputSig<Py::File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate cfgScopeSpan(
    AstSigImpl::Callable callable, Py::File file, int startLine, int startColumn, int endLine,
    int endColumn
  ) {
    exists(Py::Scope scope |
      scope = callable.asScope() and
      file = scope.getLocation().getFile() and
      scope.getLocation().hasLocationInfo(_, startLine, startColumn, endLine, endColumn)
    )
  }
}

import ControlFlow::ViewCfgQuery<Py::File, ViewCfgQueryInput>
