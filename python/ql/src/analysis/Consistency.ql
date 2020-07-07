/**
 * @name Consistency check
 * @description General consistency check to be run on any and all code. Should never produce any results.
 * @id py/consistency-check
 */

import python
import DefinitionTracking

predicate uniqueness_error(int number, string what, string problem) {
  (
    what = "toString" or
    what = "getLocation" or
    what = "getNode" or
    what = "getDefinition" or
    what = "getEntryNode" or
    what = "getOrigin" or
    what = "getAnInferredType"
  ) and
  (
    number = 0 and problem = "no results for " + what + "()"
    or
    number in [2 .. 10] and problem = number.toString() + " results for " + what + "()"
  )
}

predicate ast_consistency(string clsname, string problem, string what) {
  exists(AstNode a | clsname = a.getAQlClass() |
    uniqueness_error(count(a.toString()), "toString", problem) and
    what = "at " + a.getLocation().toString()
    or
    uniqueness_error(strictcount(a.getLocation()), "getLocation", problem) and
    what = a.getLocation().toString()
    or
    not exists(a.getLocation()) and
    not a.(Module).isPackage() and
    problem = "no location" and
    what = a.toString()
  )
}

predicate location_consistency(string clsname, string problem, string what) {
  exists(Location l | clsname = l.getAQlClass() |
    uniqueness_error(count(l.toString()), "toString", problem) and what = "at " + l.toString()
    or
    not exists(l.toString()) and
    problem = "no toString" and
    (
      exists(AstNode thing | thing.getLocation() = l |
        what = "a location of a " + thing.getAQlClass()
      )
      or
      not exists(AstNode thing | thing.getLocation() = l) and
      what = "a location"
    )
    or
    l.getEndLine() < l.getStartLine() and
    problem = "end line before start line" and
    what = "at " + l.toString()
    or
    l.getEndLine() = l.getStartLine() and
    l.getEndColumn() < l.getStartColumn() and
    problem = "end column before start column" and
    what = "at " + l.toString()
  )
}

predicate cfg_consistency(string clsname, string problem, string what) {
  exists(ControlFlowNode f | clsname = f.getAQlClass() |
    uniqueness_error(count(f.getNode()), "getNode", problem) and
    what = "at " + f.getLocation().toString()
    or
    not exists(f.getLocation()) and
    not exists(Module p | p.isPackage() | p.getEntryNode() = f or p.getAnExitNode() = f) and
    problem = "no location" and
    what = f.toString()
    or
    uniqueness_error(count(f.(AttrNode).getObject()), "getValue", problem) and
    what = "at " + f.getLocation().toString()
  )
}

predicate scope_consistency(string clsname, string problem, string what) {
  exists(Scope s | clsname = s.getAQlClass() |
    uniqueness_error(count(s.getEntryNode()), "getEntryNode", problem) and
    what = "at " + s.getLocation().toString()
    or
    uniqueness_error(count(s.toString()), "toString", problem) and
    what = "at " + s.getLocation().toString()
    or
    uniqueness_error(strictcount(s.getLocation()), "getLocation", problem) and
    what = "at " + s.getLocation().toString()
    or
    not exists(s.getLocation()) and
    problem = "no location" and
    what = s.toString() and
    not s.(Module).isPackage()
  )
}

string best_description_builtin_object(Object o) {
  o.isBuiltin() and
  (
    result = o.toString()
    or
    not exists(o.toString()) and py_cobjectnames(o, result)
    or
    not exists(o.toString()) and
    not py_cobjectnames(o, _) and
    result = "builtin object of type " + o.getAnInferredType().toString()
    or
    not exists(o.toString()) and
    not py_cobjectnames(o, _) and
    not exists(o.getAnInferredType().toString()) and
    result = "builtin object"
  )
}

private predicate introspected_builtin_object(Object o) {
  /*
   * Only check objects from the extractor, missing data for objects generated from C source code analysis is OK.
   * as it will be ignored if it doesn't match up with the introspected form.
   */

  py_cobject_sources(o, 0)
}

predicate builtin_object_consistency(string clsname, string problem, string what) {
  exists(Object o |
    clsname = o.getAQlClass() and
    what = best_description_builtin_object(o) and
    introspected_builtin_object(o)
  |
    not exists(o.getAnInferredType()) and
    not py_cobjectnames(o, _) and
    problem = "neither name nor type"
    or
    uniqueness_error(count(string name | py_cobjectnames(o, name)), "name", problem)
    or
    not exists(o.getAnInferredType()) and problem = "no results for getAnInferredType"
    or
    not exists(o.toString()) and
    problem = "no toString" and
    not exists(string name | name.prefix(7) = "_semmle" | py_special_objects(o, name)) and
    not o = unknownValue()
  )
}

predicate source_object_consistency(string clsname, string problem, string what) {
  exists(Object o | clsname = o.getAQlClass() and not o.isBuiltin() |
    uniqueness_error(count(o.getOrigin()), "getOrigin", problem) and
    what = "at " + o.getOrigin().getLocation().toString()
    or
    not exists(o.getOrigin().getLocation()) and problem = "no location" and what = "??"
    or
    not exists(o.toString()) and
    problem = "no toString" and
    what = "at " + o.getOrigin().getLocation().toString()
    or
    strictcount(o.toString()) > 1 and problem = "multiple toStrings()" and what = o.toString()
  )
}

predicate ssa_consistency(string clsname, string problem, string what) {
  /* Zero or one definitions of each SSA variable */
  exists(SsaVariable var | clsname = var.getAQlClass() |
    uniqueness_error(strictcount(var.getDefinition()), "getDefinition", problem) and
    what = var.getId()
  )
  or
  /* Dominance criterion: Definition *must* dominate *all* uses. */
  exists(SsaVariable var, ControlFlowNode defn, ControlFlowNode use |
    defn = var.getDefinition() and use = var.getAUse()
  |
    not defn.strictlyDominates(use) and
    not defn = use and
    /* Phi nodes which share a flow node with a use come *before* the use */
    not (exists(var.getAPhiInput()) and defn = use) and
    clsname = var.getAQlClass() and
    problem = "a definition which does not dominate a use at " + use.getLocation() and
    what = var.getId() + " at " + var.getLocation()
  )
  or
  /* Minimality of phi nodes */
  exists(SsaVariable var |
    strictcount(var.getAPhiInput()) = 1 and
    var
        .getAPhiInput()
        .getDefinition()
        .getBasicBlock()
        .strictlyDominates(var.getDefinition().getBasicBlock())
  |
    clsname = var.getAQlClass() and
    problem = " a definition which is dominated by the definition of an incoming phi edge." and
    what = var.getId() + " at " + var.getLocation()
  )
}

predicate function_object_consistency(string clsname, string problem, string what) {
  exists(FunctionObject func | clsname = func.getAQlClass() |
    what = func.getName() and
    (
      count(func.descriptiveString()) = 0 and problem = "no descriptiveString()"
      or
      exists(int c | c = strictcount(func.descriptiveString()) and c > 1 |
        problem = c + "descriptiveString()s"
      )
    )
    or
    not exists(func.getName()) and what = "?" and problem = "no name"
  )
}

predicate multiple_origins_per_object(Object obj) {
  not obj.isC() and
  not obj instanceof ModuleObject and
  exists(ControlFlowNode use, Context ctx |
    strictcount(ControlFlowNode orig | use.refersTo(ctx, obj, _, orig)) > 1
  )
}

predicate intermediate_origins(ControlFlowNode use, ControlFlowNode inter, Object obj) {
  exists(ControlFlowNode orig, Context ctx | not inter = orig |
    use.refersTo(ctx, obj, _, inter) and
    inter.refersTo(ctx, obj, _, orig) and
    // It can sometimes happen that two different modules (e.g. cPickle and Pickle)
    // have the same attribute, but different origins.
    not strictcount(Object val | inter.(AttrNode).getObject().refersTo(val)) > 1
  )
}

predicate points_to_consistency(string clsname, string problem, string what) {
  exists(Object obj |
    multiple_origins_per_object(obj) and
    clsname = obj.getAQlClass() and
    problem = "multiple origins for an object" and
    what = obj.toString()
  )
  or
  exists(ControlFlowNode use, ControlFlowNode inter, Object obj |
    intermediate_origins(use, inter, obj) and
    clsname = use.getAQlClass() and
    problem = "has intermediate origin " + inter and
    what = use.toString()
  )
}

predicate jump_to_definition_consistency(string clsname, string problem, string what) {
  problem = "multiple (jump-to) definitions" and
  exists(Expr use |
    strictcount(getUniqueDefinition(use)) > 1 and
    clsname = use.getAQlClass() and
    what = use.toString()
  )
}

predicate file_consistency(string clsname, string problem, string what) {
  exists(File file, Folder folder |
    clsname = file.getAQlClass() and
    problem = "has same name as a folder" and
    what = file.getAbsolutePath() and
    what = folder.getAbsolutePath()
  )
  or
  exists(Container f |
    clsname = f.getAQlClass() and
    uniqueness_error(count(f.toString()), "toString", problem) and
    what = "file " + f.getName()
  )
}

predicate class_value_consistency(string clsname, string problem, string what) {
  exists(ClassValue value, ClassValue sup, string attr |
    what = value.getName() and
    sup = value.getASuperType() and
    exists(sup.lookup(attr)) and
    not value.failedInference(_) and
    not exists(value.lookup(attr)) and
    clsname = value.getAQlClass() and
    problem = "no attribute '" + attr + "', but super type '" + sup.getName() + "' does."
  )
}

from string clsname, string problem, string what
where
  ast_consistency(clsname, problem, what) or
  location_consistency(clsname, problem, what) or
  scope_consistency(clsname, problem, what) or
  cfg_consistency(clsname, problem, what) or
  ssa_consistency(clsname, problem, what) or
  builtin_object_consistency(clsname, problem, what) or
  source_object_consistency(clsname, problem, what) or
  function_object_consistency(clsname, problem, what) or
  points_to_consistency(clsname, problem, what) or
  jump_to_definition_consistency(clsname, problem, what) or
  file_consistency(clsname, problem, what) or
  class_value_consistency(clsname, problem, what)
select clsname + " " + what + " has " + problem
