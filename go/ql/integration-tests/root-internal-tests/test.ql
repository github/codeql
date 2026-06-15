import go

// Verify that root internal test files are extracted
// when nested packages also have tests
from File f
where f.getBaseName().matches("%_test.go")
select f.getRelativePath()

query predicate testFunctions(string name, string file) {
  exists(FuncDecl fn |
    fn.getName().matches("Test%") and
    name = fn.getName() and
    file = fn.getFile().getRelativePath()
  )
}
