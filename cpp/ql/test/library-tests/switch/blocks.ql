import cpp

from Function f, BlockStmt b
where b = f.getEntryPoint()
select f, b, b.getAStmt()
