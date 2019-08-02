/**
 * @id js/examples/propaccess
 * @name Property accesses
 * @description Finds property accesses of the form `x.innerHTML`
 * @tags property
 *       field
 *       access
 *       read
 *       write
 *       reference
 */

import javascript

from PropAccess p
where p.getPropertyName() = "innerHTML"
select p
