import ql
private import codeql_ql.ast.internal.AstNodes as AstNodes

query AstNode nonTotalGetParent() {
  exists(AstNodes::toQL(result).getParent()) and
  not exists(result.getParent()) and
  not result.getLocation().getStartColumn() = 1 and // startcolumn = 1 <=> top level in file <=> fine to have no parent
  not result instanceof YAML::YAMLNode and // parents for YAML doens't work
  not (result instanceof QLDoc and result.getLocation().getFile().getExtension() = "dbscheme") // qldoc in dbschemes are not hooked up
}
