import python

from LocalVariable v, Scope inner
where
  v.escapes() and
  inner = v.getAnAccess().getScope() and
  inner != v.getScope()
select v.toString(), v.getScope().toString(), inner.toString()
