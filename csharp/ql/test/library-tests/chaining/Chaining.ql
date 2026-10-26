import semmle.code.csharp.Chaining

from Callable c
where designedForChaining(c) and c.fromSource()
select c
