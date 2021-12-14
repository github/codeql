import java

class EmptyBlock extends Block {
  EmptyBlock() {
    this.getNumStmt() = 0
  }
}

from IfStmt ifstmt
where ifstmt.getThen() instanceof
      EmptyBlock
select ifstmt
