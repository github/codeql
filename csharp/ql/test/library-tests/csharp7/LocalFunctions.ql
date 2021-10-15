import csharp

from LocalFunction fn
select fn, fn.getName(), fn.getReturnType().toString(), fn.getParent(), fn.getStatement(),
  fn.toStringWithTypes()
