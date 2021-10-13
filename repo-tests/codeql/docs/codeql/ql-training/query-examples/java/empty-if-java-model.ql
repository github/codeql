import java

class EmptyBlock extends Block {
  EmptyBlock() { this.getNumStmt() = 0 }
}

from IfStmt ifstmt
where
  ifstmt.getThen() instanceof EmptyBlock and
  not exists(ifstmt.getElse())
select ifstmt, "This if-statement is redundant."