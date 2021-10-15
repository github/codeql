import semmle.javascript.dependencies.FrameworkLibraries

class FooTools extends FrameworkLibrary {
  FooTools() { this = "footools" }
}

class FooToolsInstance extends FrameworkLibraryInstance {
  FooToolsInstance() {
    exists(Comment c | c.getTopLevel() = this | c.getText().matches("%FooTools%"))
  }

  override predicate info(FrameworkLibrary fl, string v) {
    fl instanceof FooTools and
    v = "1.2.3"
  }
}
