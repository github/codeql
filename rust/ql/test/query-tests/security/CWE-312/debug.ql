import rust

string describe(Locatable l) {
    result = "target:" + l.(CallExpr).getFunction().getAQlClass()
    or
    result = "target-path:" + l.(CallExpr).getFunction().(PathExpr).getResolvedPath()
    or
    result = "target-origin:" + l.(CallExpr).getFunction().(PathExpr).getResolvedCrateOrigin()
    or
    result = "method-path:" + l.(MethodCallExpr).getResolvedPath()
    or
    result = "method-origin:" + l.(MethodCallExpr).getResolvedCrateOrigin()
    or
    result = "static-target:" + l.(CallExprBase).getStaticTarget().getAQlClass() // resolved call
}

from Locatable l
where l.getFile().getBaseName() = "test_logging.rs"
select l, l.getLocation().getStartLine(), concat(l.getAQlClass(), ", "), concat(describe(l), ", ")
