/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id go/ide-jump-to-definition
 * @tags ide-contextual-queries/local-definitions
 */

import go

external string selectedSourceFile();

cached
File getEncodedFile(string name) { result.getAbsolutePath().replaceAll(":", "_") = name }

from Ident def, Ident use, Entity e
where use.uses(e) and def.declares(e) and use.getFile() = getEncodedFile(selectedSourceFile())
select use, def, "V"
