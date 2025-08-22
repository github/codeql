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

from Class c, Type superType
where
  c.getSourceDeclaration().fromSource() and
  superType = c.getASupertype()
select c, superType

query predicate extendsOrImplements(ClassOrInterface c, Type superType, string kind) {
  c.getSourceDeclaration().fromSource() and
  (
    extendsReftype(c, superType) and kind = "extends"
    or
    implInterface(c, superType) and kind = "implements"
  )
}
