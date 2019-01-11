import javascript

from ExprStmt e, Identifier interface, Identifier id, Function f
where e.isDoubleColonMethod(interface, id, f)
select e, interface, id, f
