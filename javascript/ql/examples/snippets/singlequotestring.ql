/**
 * @id js/examples/singlequotestring
 * @name Single-quoted string literals
 * @description Finds string literals using single quotes
 * @tags string
 *       single quote
 *       quote
 */

import javascript

from StringLiteral s
where s.getRawValue().charAt(0) = "'"
select s
