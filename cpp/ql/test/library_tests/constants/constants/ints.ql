import cpp

from LocalVariable v, Literal l, string clazz
where
  l = v.getInitializer().getExpr() and
  v.getFunction().hasName("integers") and
  clazz = l.getAQlClass() and
  (clazz.matches("%Literal") or clazz = "Zero")
select v, l.getValue(), l.getValueText(), clazz
