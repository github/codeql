import javascript

from FunctionDeclStmt f, FunctionDeclStmt g
where f != g and f.getVariable() = g.getVariable() and
    not f.getTopLevel().isMinified() and
    not g.getTopLevel().isMinified()
select f, g
