import java

string topToString(Top t) {
  result = t.toString()
  or
  // TypeBound doesn't extend Top (but probably should); part of Kotlin #6
  result = t.(TypeBound).toString()
  or
  // XMLLocatable doesn't extend Top (but probably should); part of Kotlin #6
  result = t.(XmlLocatable).toString()
  or
  // Java #142
  t instanceof FieldDeclaration and not exists(t.toString()) and result = "<FieldDeclaration>"
  or
  // Java #143
  t instanceof Javadoc and not exists(t.toString()) and result = "<Javadoc>"
  or
  // Java #144
  t instanceof ReflectiveAccessAnnotation and
  not exists(t.toString()) and
  result = "<ReflectiveAccessAnnotation>"
}

string not1ToString() {
  exists(Top t |
    count(topToString(t)) != 1 and result = "Top which doesn't have exactly 1 toString"
  )
  or
  exists(Location l |
    count(l.toString()) != 1 and result = "Location which doesn't have exactly 1 toString"
  )
  or
  exists(Module m |
    count(m.toString()) != 1 and result = "Module which doesn't have exactly 1 toString"
  )
  or
  exists(Directive d |
    count(d.toString()) != 1 and result = "Directive which doesn't have exactly 1 toString"
  )
}

select not1ToString()
