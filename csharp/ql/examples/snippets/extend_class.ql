/**
 * @id cs/examples/extend-class
 * @name Class extends/implements
 * @description Finds classes/interfaces that extend/implement 'System.Collections.IEnumerator'.
 * @tags class
 *       extends
 *       implements
 *       overrides
 *       subtype
 *       supertype
 */

import csharp

from RefType type
where type.getABaseType+().hasQualifiedName("System.Collections.IEnumerator")
select type
