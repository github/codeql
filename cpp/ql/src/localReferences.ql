/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id cpp/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import definitions

external string selectedSourceFile();

cached
File getEncodedFile(string name) { result.getAbsolutePath().replaceAll(":", "_") = name }

from Top e, Top def, string kind
where def = definitionOf(e, kind) and def.getFile() = getEncodedFile(selectedSourceFile())
select e, def, kind
