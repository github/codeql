/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer of VSCode.
 * @kind definitions
 * @id cpp/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import definitions

external string selectedSourceFile();

from Top e, Top def, string kind
where def = definitionOf(e, kind) and e.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
