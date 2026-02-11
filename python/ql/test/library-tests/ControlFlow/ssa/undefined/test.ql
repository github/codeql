import python
private import LegacyPointsTo

from SsaVariableWithPointsTo var
where var.maybeUndefined()
select var.getDefinition().getLocation().getStartLine(), var.toString()
