/**
 * @id py/examples/raw-string
 * @name Raw string literals
 * @description Finds string literals with an 'r' prefix
 * @tags string
 *       raw
 */

import python

from StrConst s
where s.getPrefix().matches("%r%")
select s
