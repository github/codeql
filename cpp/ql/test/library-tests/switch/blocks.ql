import cpp

from Function f, Block b
where b = f.getEntryPoint()
select f, b, b.getAStmt()
