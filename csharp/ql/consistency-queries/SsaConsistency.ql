import csharp
import semmle.code.csharp.dataflow.internal.SsaImplCommon::Consistency
import Ssa

class MyRelevantDefinition extends RelevantDefinition, Ssa::Definition {
  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

query predicate localDeclWithSsaDef(LocalVariableDeclExpr d) {
  // Local variables in C# must be initialized before every use, so uninitialized
  // local variables should not have an SSA definition, as that would imply that
  // the declaration is live (can reach a use without passing through a definition)
  exists(ExplicitDefinition def |
    d = def.getADefinition().(AssignableDefinitions::LocalVariableDefinition).getDeclaration()
  |
    not d = any(ForeachStmt fs).getVariableDeclExpr() and
    not d = any(SpecificCatchClause scc).getVariableDeclExpr() and
    not d.getVariable().getType() instanceof Struct and
    not d instanceof PatternExpr and
    not d.getVariable().isCaptured()
  )
}
