import java

// Stop external filepaths from appearing in the results
class ClassOrInterfaceLocation extends ClassOrInterface {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(string fullPath | super.hasLocationInfo(fullPath, sl, sc, el, ec) |
      if exists(this.getFile().getRelativePath())
      then path = fullPath
      else path = fullPath.regexpReplaceAll(".*/", "<external>/")
    )
  }
}

class MethodLocation extends Method {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(string fullPath | super.hasLocationInfo(fullPath, sl, sc, el, ec) |
      if exists(this.getFile().getRelativePath())
      then path = fullPath
      else path = fullPath.regexpReplaceAll(".*/", "<external>/")
    )
  }
}

from MethodCall ma, Method m
where
  ma.getFile().(CompilationUnit).fromSource() and
  m = ma.getMethod()
select ma, m, m.getQualifiedName(), m.getDeclaringType()
