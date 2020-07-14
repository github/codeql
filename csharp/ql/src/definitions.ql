/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id cs/jump-to-definition
 */

import definitions

from Use use, Declaration def, string kind
where def = definitionOf(use, kind)
select use, def, kind
