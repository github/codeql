/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id java/jump-to-definition
 */

import definitions

from Element e, Element def, string kind
where def = definitionOf(e, kind)
select e, def, kind
