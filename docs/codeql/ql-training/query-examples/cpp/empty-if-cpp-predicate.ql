import cpp

predicate isEmpty(Block block) {
  block.isEmpty()
}

from IfStmt ifstmt
where isEmpty(ifstmt.getThen())
select ifstmt, "This if-statement is redundant."