import csharp

from DelegateType del
where
  del.fromSource() and
  del.getAnnotatedReturnType().isReadonlyRef()
select del
