/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id js/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import definitions

external string selectedSourceFile();

from Locatable e, AstNode def, string kind
where def = definitionOf(e, kind) and e.getFile() = getFileBySourceArchiveName(selectedSourceFile())
select e, def, kind
