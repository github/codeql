/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer.
 * @kind definitions
 * @id go/jump-to-definition
 */

import go

from Ident def, Ident use, Entity e
where
  use.uses(e) and
  def.declares(e)
select use, def, "V"
