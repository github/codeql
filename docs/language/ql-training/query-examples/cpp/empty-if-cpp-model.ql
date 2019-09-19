import cpp

class EmptyBlock extends Block {
  EmptyBlock() { this.isEmpty() }
}

from IfStmt ifstmt
where
  ifstmt.getThen() instanceof EmptyBlock and
  not exists(ifstmt.getElse())
select ifstmt, "This if-statement is redundant."