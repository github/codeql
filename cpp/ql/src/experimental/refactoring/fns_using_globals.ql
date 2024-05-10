// Flags use of global variables
import cpp
import relevant


from RelevantGlobalVariable globalVariable, string typeName, Function fn, VariableAccess va
where
  typeName = globalVariable.getType().stripType().getName()
  and fn = globalVariable.getAnAccess().getEnclosingFunction()
select globalVariable, fn
