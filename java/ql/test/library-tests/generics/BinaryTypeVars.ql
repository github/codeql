import default

from TypeVariable tv, string qname
where
  exists(GenericType gt |
    gt = tv.getGenericType() and
    gt.hasQualifiedName("java.util", "HashMap") and
    qname = gt.getQualifiedName()
  )
  or
  exists(GenericCallable gm |
    gm = tv.getGenericCallable() and
    gm.hasName("asList") and
    gm.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
    qname = gm.getDeclaringType().getQualifiedName() + "." + gm.getSignature()
  )
select tv.getName(), qname
