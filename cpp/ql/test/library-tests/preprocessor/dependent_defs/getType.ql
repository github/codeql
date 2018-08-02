import cpp

Type getType(Element e) {
  // A function may get more than one return type if it's declared in different
  // preprocessor contexts.
  result = e.(Function).getType()
  or
  result = e.(Variable).getType()
  or
  result = e.(TypedefType).getBaseType()
}

from Element e
where e.getFile().fromSource()
select e, getType(e), count(getType(e))
