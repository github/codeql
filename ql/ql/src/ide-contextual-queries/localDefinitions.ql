/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id ql/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import ql
import Definitions
import codeql.IDEContextual

external string selectedSourceFile();

from Loc ref, Loc target, string kind
where
  resolve(ref, target, kind) and
  ref.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select ref, target, kind
