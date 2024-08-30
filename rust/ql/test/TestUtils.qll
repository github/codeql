private import codeql.rust.elements

cached
predicate toBeTested(Element e) {
  exists(File f |
    f.getName().matches("%rust/ql/test%") and
    (
      e = f
      or
      e.(Locatable).getLocation().getFile() = f
    )
  )
}
