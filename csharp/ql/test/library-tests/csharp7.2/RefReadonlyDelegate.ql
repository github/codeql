import csharp

from DelegateType del
where
  del.fromSource() and
  del.getAnnotatedReturnType().getAnnotation().isReadonlyRef()
select del
