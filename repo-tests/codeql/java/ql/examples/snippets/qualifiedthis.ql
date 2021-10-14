/**
 * @id java/examples/qualifiedthis
 * @name Qualified 'this' access
 * @description Finds 'this' accesses that are qualified by a type name
 * @tags this
 *       access
 *       qualifier
 */

import java

from ThisAccess t
where exists(t.getQualifier())
select t
