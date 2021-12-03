import csharp

from Stmt s, Stmt stripped
where stripped = s.stripSingletonBlocks() and s != stripped
select s, stripped
