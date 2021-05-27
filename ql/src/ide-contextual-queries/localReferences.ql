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

from ModuleRef ref, FileOrModule target, string kind
where
  target = ref.getResolvedModule() and
  kind = "module" and
  ref.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select ref, target, kind
