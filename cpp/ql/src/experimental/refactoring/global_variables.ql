// Flags use of global variables
import cpp
import relevant


from RelevantGlobalVariable globalVariable, string typeName
where
  typeName = globalVariable.getType().stripType().getName()
select globalVariable, typeName, globalVariable.getFile().getRelativePath()