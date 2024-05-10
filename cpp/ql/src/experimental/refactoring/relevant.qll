import cpp

predicate is_relevant_result(File file)
{
    not file.getRelativePath().matches("c/extractor/edg%")
}

class RelevantGlobalVariable extends GlobalVariable
{
  RelevantGlobalVariable() {
    not is_valid_global_variable(this) and 
    exists(this.getFile().getRelativePath()) // From the repo
  }
}

predicate is_valid_global_variable(Variable var) {
  var.getType().stripType().getName() = "trie_node" or
  var.getType().isConst() or
  var.getType().isDeeplyConst() or
  var.isConstexpr() or
  // var.getType() instanceof ArrayType or
  var.getASpecifier().getName() = "extern" or
  var.getFile().getRelativePath().matches("c/extractor/edg/%") // or
  // var.getFile().getRelativePath().matches("c/extractor/edg%") or
}
