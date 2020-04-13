/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id cpp/jump-to-definition
 * @tags local-definitions
 */

import definitions

external string selectedSourceFile();

cached File getEncodedFile(string name) {
        result.getAbsolutePath().replaceAll(":", "_") = name
}



from Top e, Top def, string kind
where def = definitionOf(e, kind) and e.getFile() = getEncodedFile(selectedSourceFile())
select e, def, kind
