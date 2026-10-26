import cpp

from NameQualifiableElement e
where
  e.hasGlobalQualifiedName() and
  e instanceof Expr
select e
