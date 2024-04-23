// Flags use of global variables
import cpp

class RelevantGlobalVariable extends GlobalVariable
{
  RelevantGlobalVariable() {
    any()
  }
}

predicate is_valid_global_variable(Variable var) {
  var.getType().stripType().getName() = "trie_node" or
  var.getType().isConst() or
  var.getType().isDeeplyConst() or
  var.isConstexpr() or
  var.getType() instanceof ArrayType or
  var.getASpecifier().getName() = "extern" or
  var.getFile().getRelativePath().matches("c/extractor/edg/%")
}

from GlobalVariable globalVariable, string typeName
where
  not is_valid_global_variable(globalVariable) and
  typeName = globalVariable.getType().stripType().getName()
select globalVariable, typeName, globalVariable.getFile().getRelativePath()
