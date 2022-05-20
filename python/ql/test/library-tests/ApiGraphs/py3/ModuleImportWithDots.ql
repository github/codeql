private import python
private import semmle.python.ApiGraphs

query API::Node moduleImportWithDots() { result = API::moduleImport("a.b.c.d") }

query API::CallNode doesntFullyWork() {
  result = API::moduleImport("a.b.c.d").getMember("method").getACall()
}

query API::CallNode works() {
  result =
    API::moduleImport("a")
        .getMember("b")
        .getMember("c")
        .getMember("d")
        .getMember("method")
        .getACall()
}
