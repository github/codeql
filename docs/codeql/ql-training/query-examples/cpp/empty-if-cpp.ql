import cpp  
   
from IfStmt ifstmt, Block block
where
  block = ifstmt.getThen() and
  block.isEmpty()
select ifstmt, "This if-statement is redundant."