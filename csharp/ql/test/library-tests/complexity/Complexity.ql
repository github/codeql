import csharp

from Callable f
where
  f.getName().matches("cc_") and // cc1, cc2, ...
  f.fromSource()
select f, f.getCyclomaticComplexity()
