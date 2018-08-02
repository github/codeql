import csharp

from Callable f
where f.getName().matches("cc_") // cc1, cc2, ...
and f.fromSource()
select f, f.getCyclomaticComplexity()
