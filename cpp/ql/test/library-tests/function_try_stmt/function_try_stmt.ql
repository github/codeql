import cpp

from FunctionTryStmt fts
select fts, fts.getEnclosingFunction() as f, f.getBlock().getAStmt()
