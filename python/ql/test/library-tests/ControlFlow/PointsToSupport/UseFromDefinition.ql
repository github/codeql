import python

/*Find any Definition, assigned value pairs that 'valueForDefinition' misses */
Expr assignedValue(Name n) {
  exists(Assign a | a.getATarget() = n and result = a.getValue())
  or
  exists(Alias a | a.getAsname() = n and result = a.getValue())
}

from Name def, DefinitionNode d
where
  d.getNode() = def and
  exists(assignedValue(def)) and
  not d.getValue().getNode() = assignedValue(def)
select def.toString(), assignedValue(def)
