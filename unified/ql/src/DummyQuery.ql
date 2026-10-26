/**
 * @name Dummy query
 * @description Dummy query that flags any name longer than 100 characters
 * @kind problem
 * @id unified/dummy
 * @problem.severity error
 * @precision high
 * @security-severity 7
 * @tags security
 */

import unified

from Identifier id
where id.getValue().length() > 100
select id, "Name is too long: " + id.getValue()
