private import rust

cached
predicate toBeTested(Element e) {
  not e instanceof Locatable or
  fileIsInTest(e.(Locatable).getFile())
}

cached
predicate fileIsInTest(File f) { f.getAbsolutePath().matches("%rust/ql/test%") }
