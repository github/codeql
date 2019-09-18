import semmle.javascript.Util

select pluralize("x", 0), pluralize("x", 1), pluralize("x", 2), pluralize("x", -1)
