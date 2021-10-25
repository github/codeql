import csharp

from FixedStmt f
select f, f.getBody(), f.getBody().getAChildStmt()
