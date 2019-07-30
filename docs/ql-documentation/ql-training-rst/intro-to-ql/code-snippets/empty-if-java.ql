import java

from IfStmt ifstmt, Block block
where
  block = ifstmt.getThen() and
  block.getNumStmt() = 0
select ifstmt