/**
 * @name Find-references links
 * @description Generates use-definition pairs that provide the data
 *              for find-references in the code viewer.
 * @kind definitions
 * @id go/ide-find-references
 * @tags ide-contextual-queries/local-references
 */

import go

external string selectedSourceFile();

cached
File getEncodedFile(string name) { result.getAbsolutePath().replaceAll(":", "_") = name }

from Ident def, Ident use, Entity e
where use.uses(e) and def.declares(e) and def.getFile() = getEncodedFile(selectedSourceFile())
select use, def, "V"
