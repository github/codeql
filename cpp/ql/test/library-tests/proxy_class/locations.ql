import cpp

string clazz(Declaration d) {
  d instanceof ProxyClass and result = "ProxyClass"
  or
  d instanceof TypeTemplateParameter and result = "TypeTemplateParameter"
  or
  d instanceof Struct and result = "Struct"
}

from Declaration d
where d.getLocation().getStartLine() > 0
select d, clazz(d)
