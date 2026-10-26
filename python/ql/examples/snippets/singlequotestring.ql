/**
 * @id py/examples/singlequotestring
 * @name Single-quoted string literals
 * @description Finds string literals using single quotes
 * @tags string
 *       single quote
 *       quote
 */

import python

from StringLiteral s
where s.getPrefix().charAt(_) = "'"
select s
