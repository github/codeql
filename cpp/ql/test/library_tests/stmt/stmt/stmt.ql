import cpp

from Stmt s, string empty, string asm
where
  (if s instanceof EmptyStmt then empty = "EmptyStmt" else empty = "") and
  if s instanceof AsmStmt then asm = "AsmStmt" else asm = ""
select s, empty + asm
