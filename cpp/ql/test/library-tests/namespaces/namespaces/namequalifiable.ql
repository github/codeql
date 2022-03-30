import cpp

string describe(Element e) {
  e instanceof NameQualifiableElement and
  result = "NameQualifiableElement"
  or
  e instanceof NameQualifyingElement and
  result = "NameQualifyingElement"
}

from Element e
where e.getFile().fromSource() or e instanceof Namespace
select e, strictconcat(describe(e), ", ")
