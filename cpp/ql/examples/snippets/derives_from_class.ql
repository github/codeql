/**
 * @id cpp/examples/derives-from-class
 * @name Class derives from
 * @description Finds classes that derive from `std::exception`
 * @tags base
 *       class
 *       derive
 *       inherit
 *       override
 *       subtype
 *       supertype
 */

import cpp

from Class type
where
  type.getABaseClass+().hasName("exception") and
  type.getNamespace().getName() = "std"
select type
