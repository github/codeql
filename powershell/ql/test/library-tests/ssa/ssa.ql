import powershell
import semmle.code.powershell.dataflow.Ssa

query predicate definition(Ssa::Definition def, Variable v) { def.getSourceVariable() = v }
