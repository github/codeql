import java

string visibility(Method m) {
  result = "public" and m.isPublic()
  or
  result = "protected" and m.isProtected()
  or
  result = "private" and m.isPrivate()
  or
  result = "internal" and m.isInternal()
}

// TODO: This ought to check more than just methods
from Method m
where
  // TODO: This ought to work for everything, but for now we
  //       restrict to things in Kotlin source files
  m.getFile().isKotlinSourceFile() and
  // TODO: This ought to have visibility information
  not m.getName() = "<clinit>" and
  count(visibility(m)) != 1
select m, concat(visibility(m), ", ")
