import csharp

from EmptyStmt s1, EmptyStmt s2
where s2.reachableFrom(s1)
select s1, s2
