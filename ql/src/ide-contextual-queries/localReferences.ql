/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id ql/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import ql
import Definitions
import codeql.IDEContextual

external string selectedSourceFile();

from Loc ref, Loc target, string kind
where
  resolve(ref, target, kind) and
  target.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select ref, target, kind
