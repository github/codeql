import codeql.ruby.dataflow.SSA
import codeql.ruby.dataflow.internal.SsaImpl::Consistency as Consistency

class MyRelevantDefinition extends Consistency::RelevantDefinition, Ssa::Definition {
  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

query predicate nonUniqueDef = Consistency::nonUniqueDef/4;

query predicate readWithoutDef = Consistency::readWithoutDef/3;

query predicate deadDef = Consistency::deadDef/2;

query predicate notDominatedByDef = Consistency::notDominatedByDef/4;
