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

predicate hasPackagePrivateVisibility(Method m) { not exists(visibility(m)) }

// TODO: This ought to check more than just methods
from Method m
where
  // TODO: This ought to work for everything, but for now we
  //       restrict to things in Kotlin source files
  m.getFile().isKotlinSourceFile() and
  // TODO: This ought to have visibility information
  not m.getName() = "<clinit>" and
  count(visibility(m)) != 1 and
  not (count(visibility(m)) = 2 and visibility(m) = "public" and visibility(m) = "internal") and // This is a reasonable result, since the JVM symbol is declared public, but Kotlin metadata flags it as internal
  not (hasPackagePrivateVisibility(m) and m.getName().matches("%$default")) // This is a reasonable result because the $default forwarder methods corresponding to private methods are package-private.
select m, concat(visibility(m), ", ")
