import swift

string describe(ApplyExpr e) {
  result = "getFunction:" + e.getFunction().toString() or
  result = "getStaticTarget:" + e.getStaticTarget().toString() or
  exists(int ix | result = "getArgument(" + ix.toString() + "):" + e.getArgument(ix).toString())
}

from ApplyExpr e
where e.getFile().getBaseName() != ""
select e, concat(describe(e), ", ")
