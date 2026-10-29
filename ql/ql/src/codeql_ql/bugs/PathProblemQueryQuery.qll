import ql
private import codeql_ql.ast.internal.Module

FileOrModule hasQueryRelation(ClasslessPredicate pred) {
  pred.hasAnnotation("query") and
  (
    result.asModule().getAMember() = pred
    or
    any(TopLevel top | top.getLocation().getFile() = result.asFile()).getAMember() = pred
  )
}

FileOrModule importsQueryRelation(ClasslessPredicate pred) {
  result = hasQueryRelation(pred)
  or
  exists(Import i |
    not (i.hasAnnotation("private") and i.getLocation().getFile().getExtension() = "qll") and
    importsQueryRelation(pred) = i.getResolvedModule()
  |
    i = result.asModule().getAMember()
    or
    i = any(TopLevel top | top.getLocation().getFile() = result.asFile()).getAMember()
  )
}

class Query extends File {
  Query() { this.getExtension() = "ql" }

  predicate isPathProblem() {
    exists(QLDoc doc | doc.getLocation().getFile() = this |
      doc.getContents().matches("%@kind path-problem%")
    )
  }

  predicate isProblem() {
    exists(QLDoc doc | doc.getLocation().getFile() = this |
      doc.getContents().matches("%@kind problem%")
    )
  }

  predicate hasEdgesRelation(ClasslessPredicate pred) {
    importsQueryRelation(pred).asFile() = this and pred.getName() = "edges"
  }
}
