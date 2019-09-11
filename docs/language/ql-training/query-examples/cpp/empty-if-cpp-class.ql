import cpp

class EmptyBlock extends Block {
  EmptyBlock() {
    this.isEmpty()
  }
}

from IfStmt ifStmt
where ifstmt.getThen() instanceof EmptyBlock
select ifstmt