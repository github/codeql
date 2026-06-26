/**
 * @name Dummy query
 * @description Dummy query that flags any name longer than 20 characters
 * @kind problem
 * @id unified/dummy
 * @problem.severity info
 * @precision low
 */

import unified

from Identifier id
where id.getValue().length() > 20
select id, "Name is too long: " + id.getValue()
