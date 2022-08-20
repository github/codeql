class Foo extends string {
  Foo() { this = "Foo" }

  string getImportedPath() { none() }
}

class Bar extends string, Foo {
  Bar() { exists(Foo.super.getImportedPath()) }

  override string getImportedPath() { none() }
}
