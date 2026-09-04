/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id unified/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import codeql.Definitions
import codeql.IDEContextual
import unified

external string selectedSourceFile();

from Identifier reference, NameDeclaration definition, string kind
where
  definitionOf(reference, definition, kind) and
  reference.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
select reference, definition, kind
