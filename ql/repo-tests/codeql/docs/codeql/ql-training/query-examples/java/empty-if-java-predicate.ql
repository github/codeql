import java

predicate isEmpty(Block block) {
  block.getNumStmt() = 0
}

from IfStmt ifstmt
where isEmpty(ifstmt.getThen())
select ifstmt