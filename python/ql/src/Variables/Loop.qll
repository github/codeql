import python

private predicate empty_sequence(Expr e) {
  exists(SsaVariable var | var.getAUse().getNode() = e |
    empty_sequence(var.getDefinition().getNode())
  )
  or
  e instanceof List and not exists(e.(List).getAnElt())
  or
  e instanceof Tuple and not exists(e.(Tuple).getAnElt())
  or
  e.(StrConst).getText().length() = 0
}

/* This has the potential for refinement, but we err on the side of fewer false positives for now. */
private predicate probably_non_empty_sequence(Expr e) { not empty_sequence(e) }

/** A loop which probably defines v */
private Stmt loop_probably_defines(Variable v) {
  exists(Name defn | defn.defines(v) and result.contains(defn) |
    probably_non_empty_sequence(result.(For).getIter())
    or
    probably_non_empty_sequence(result.(While).getTest())
  )
}

/** Holds if the variable used by `use` is probably defined in a loop */
predicate probably_defined_in_loop(Name use) {
  exists(Stmt loop | loop = loop_probably_defines(use.getVariable()) |
    loop.getAFlowNode().strictlyReaches(use.getAFlowNode())
  )
}

/** Holds if `s` is a loop that probably executes at least once */
predicate loop_probably_executes_at_least_once(Stmt s) {
  probably_non_empty_sequence(s.(For).getIter())
  or
  probably_non_empty_sequence(s.(While).getTest())
}
