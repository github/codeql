import python
import semmle.python.pointsto.PointsTo
import semmle.python.objects.ObjectInternal

predicate ssa_consistency(string clsname, string problem, string what) {
  /* Exactly one definition of each SSA variable */
  exists(EssaVariable var | clsname = var.getAQlClass() |
    /* Exactly one definition of each SSA variable */
    count(var.getDefinition()) != 1 and
    problem = " has " + count(var.getDefinition()) + " definitions." and
    what = "SSA variable " + var.getSourceVariable().getName()
    or
    /* Backing variable */
    not exists(var.getSourceVariable()) and
    problem = "An SSA variable has no backing variable." and
    what = "An SSA variable"
    or
    count(var.getSourceVariable()) != 1 and
    problem =
      var.getSourceVariable().getName() + " has " + count(var.getSourceVariable()) +
        " backing variables." and
    what = "SSA variable " + var.getSourceVariable().getName()
  )
  or
  /* Exactly one location */
  exists(EssaDefinition def |
    clsname = def.getAQlClass() and
    what =
      "SSA Definition " + def.getSourceVariable().getName() + " in " +
        def.getSourceVariable().(Variable).getScope().getName() and
    count(def.getLocation()) != 1 and
    problem = " has " + count(def.getLocation()) + " locations"
  )
  or
  /* Must have a source variable */
  exists(EssaDefinition def |
    clsname = def.getAQlClass() and
    not exists(def.getSourceVariable()) and
    what = " at " + def.getLocation() and
    problem = "has not source variable"
  )
  or
  /* Variables must have exactly one representation */
  exists(EssaVariable var |
    clsname = var.getAQlClass() and
    what =
      "SSA variable " + var.getSourceVariable().getName() + " defined at " +
        var.getDefinition().getLocation() and
    count(var.getRepresentation()) != 1 and
    problem = " has " + count(var.getRepresentation()) + " representations"
  )
  or
  /* Definitions must have exactly one representation */
  exists(EssaDefinition def |
    clsname = def.getAQlClass() and
    what = "SSA definition " + def.getSourceVariable().getName() + " at " + def.getLocation() and
    count(def.getRepresentation()) != 1 and
    problem =
      " has " + count(def.getRepresentation()) + " representations: " + def.getRepresentation()
  )
  or
  /* Refinements must have exactly one input */
  exists(EssaNodeRefinement ref |
    clsname = ref.getAQlClass() and
    what = "Refinement " + ref.getSourceVariable().getName() + " at " + ref.getLocation() and
    count(ref.getInput()) != 1 and
    problem = " has " + count(ref.getInput()) + " inputs: " + ref.getInput().getRepresentation()
  )
  or
  /*
   * Ideally filter nodes should have exactly one input, but it is not a big deal
   * if we prune away the input, leaving it with none.
   */

  exists(EssaEdgeRefinement def |
    clsname = def.getAQlClass() and
    what = def.getSourceVariable().getName() + " at " + def.getLocation()
  |
    count(def.getInput()) > 1 and problem = " has " + count(def.getInput()) + " inputs."
  )
  or
  /* Each use has only one reaching SSA variable */
  exists(ControlFlowNode use, SsaSourceVariable v, int c |
    c = strictcount(EssaVariable s | s.getAUse() = use and s.getSourceVariable() = v) and
    clsname = use.getAQlClass() and
    c != 1 and
    what = use + " at " + use.getLocation() and
    problem = " has " + c + " SSA variables reaching."
  )
  or
  /* Python-specific subclasses of EssaDefinitions should be disjoint and complete */
  exists(EssaDefinition def |
    clsname = def.getAQlClass() and
    what = def.getVariable().getName() + " at " + def.getLocation() and
    problem = "has non-disjoint subclasses"
  |
    strictcount(def.getAQlClass()) > 2
    or
    /* OK if method call and argument overlap:  `x.foo(x)` */
    strictcount(def.getAQlClass()) > 1 and
    not clsname = "ArgumentRefinement" and
    not clsname = "SelfCallsiteRefinement"
  )
  or
  exists(EssaDefinition def |
    clsname = def.getAQlClass() and
    clsname.prefix(4) = "Essa" and
    what = " at " + def.getLocation() and
    problem = "not covered by Python-specific subclass."
  )
  or
  // All modules should have __name__
  exists(Module m |
    what = " at " + m.getLocation() and
    clsname = "Module"
  |
    not exists(m.getName()) and
    problem = "does not have a name"
    or
    not m.isPackage() and
    not exists(Variable v | v.getId() = "__name__" and v.getScope() = m) and
    problem = "does not have a __name__ variable"
    or
    not m.isPackage() and
    not exists(EssaNodeDefinition def |
      def.getDefiningNode().getScope() = m and
      def.getVariable().getName() = "__name__"
    ) and
    problem = "does not have an ImplicitModuleNameDefinition"
  )
}

predicate undefined_consistency(string clsname, string problem, string what) {
  /* Variables may be undefined, but values cannot be */
  exists(ControlFlowNode f |
    PointsToInternal::pointsTo(f, _, ObjectInternal::undefined(), _) and
    clsname = f.getAQlClass() and
    not clsname = "AnyNode" and
    problem = " points-to an undefined variable" and
    what = f.toString()
  )
}

from string clsname, string problem, string what
where ssa_consistency(clsname, problem, what) or undefined_consistency(clsname, problem, what)
select clsname, what, problem
