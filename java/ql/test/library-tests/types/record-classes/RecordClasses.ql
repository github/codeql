import java

from Record r, boolean isFinal, boolean isStatic, string superTypes
where
  (if r.isFinal() then isFinal = true else isFinal = false) and
  (if r.isStatic() then isStatic = true else isStatic = false) and
  superTypes = concat(RefType superType | superType = r.getASupertype() | superType.toString(), ",")
select r, "final=" + isFinal, "static=" + isStatic, superTypes
