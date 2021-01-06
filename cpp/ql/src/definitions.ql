/**
 * @name Jump-to-definition links
 * @description Generates use-definition pairs that provide the data
 *              for jump-to-definition in the code viewer of LGTM.
 * @kind definitions
 * @id cpp/jump-to-definition
 */

import definitions

from Top e, Top def, string kind
where
  def = definitionOf(e, kind) and
  // We need to exclude definitions for elements inside template instantiations,
  // as these often lead to multiple links to definitions from the same source location.
  // LGTM does not support this bevaviour.
  not e.isFromTemplateInstantiation(_)
select e, def, kind
