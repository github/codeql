/**
 * @name Print CFG
 * @description Produces a representation of a file's Control Flow Graph.
 *              This query is used by the VS Code extension.
 * @id cs/print-cfg
 * @kind graph
 * @tags ide-contextual-queries/print-cfg
 */

import csharp

external string selectedSourceFile();

private predicate selectedSourceFileAlias = selectedSourceFile/0;

external int selectedSourceLine();

private predicate selectedSourceLineAlias = selectedSourceLine/0;

external int selectedSourceColumn();

private predicate selectedSourceColumnAlias = selectedSourceColumn/0;

module ViewCfgQueryInput implements ControlFlow::ViewCfgQueryInputSig<File> {
  predicate selectedSourceFile = selectedSourceFileAlias/0;

  predicate selectedSourceLine = selectedSourceLineAlias/0;

  predicate selectedSourceColumn = selectedSourceColumnAlias/0;

  predicate cfgScopeSpan(
    Callable scope, File file, int startLine, int startColumn, int endLine, int endColumn
  ) {
    file = scope.getFile() and
    scope.getLocation().getStartLine() = startLine and
    scope.getLocation().getStartColumn() = startColumn and
    exists(Location loc |
      loc.getEndLine() = endLine and
      loc.getEndColumn() = endColumn
    |
      loc = scope.(Callable).getBody().getLocation()
      or
      loc = any(AssignExpr init | scope.(ObjectInitMethod).initializes(init)).getLocation()
      or
      exists(AssignableMember a, Constructor ctor |
        scope = ctor and
        ctor.isStatic() and
        a.isStatic() and
        a.getDeclaringType() = ctor.getDeclaringType()
      |
        loc = a.(Field).getInitializer().getLocation()
        or
        loc = a.(Property).getInitializer().getLocation()
      )
    )
  }
}

import ControlFlow::ViewCfgQuery<File, ViewCfgQueryInput>
