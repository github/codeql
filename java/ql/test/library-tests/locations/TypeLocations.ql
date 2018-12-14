import default

// restrict to built-in types accessed from source and source-level types to avoid dependencies on JDK version
from Type t, string fp, int sl, int sc, int el, int ec
where
  (
    t instanceof PrimitiveType
    or
    t instanceof VoidType
    or
    t instanceof NullType
    or
    t instanceof Wildcard and exists(WildcardTypeAccess wta | wta.getType() = t)
    or
    t instanceof Array and exists(ArrayTypeAccess ata | ata.getType() = t)
    or
    t.fromSource()
  ) and
  t.hasLocationInfo(fp, sl, sc, el, ec)
select t
