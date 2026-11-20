import swift

from ConditionElement e, AstNode underlying
where
  e.getLocation().getFile().getName().contains("swift/ql/test") and
  (
    underlying = e.getBoolean() or
    underlying = e.getPattern() or
    underlying = e.getInitializer()
  )
select e, underlying
