/**
 * Contains utility functions for writing data flow queries
 */

private import DataFlowPrivate
import DataFlowPublic

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) { simpleLocalFlowStep(nodeFrom, nodeTo) }

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * DEPRECATED. Use the API graphs library (`semmle.python.ApiGraphs`) instead.
 *
 * For a drop-in replacement, use `API::moduleImport(name).getAUse()`.
 *
 * Gets a `Node` that refers to the module referenced by `name`.
 * Note that for the statement `import pkg.mod`, the new variable introduced is `pkg` that is a
 * reference to the module `pkg`.
 *
 * This predicate handles (with optional `... as <new-name>`):
 * 1. `import <name>`
 * 2. `from <package> import <module>` when `<name> = <package> + "." + <module>`
 * 3. `from <module> import <member>` when `<name> = <module> + "." + <member>`
 *
 * Finally, in `from <module> import <member>` we consider the `ImportExpr` corresponding to
 * `<module>` to be a reference to that module.
 *
 * Note:
 * While it is technically possible that `import mypkg.foo` and `from mypkg import foo` can give different values,
 * it's highly unlikely that this will be a problem in production level code.
 *   Example: If `mypkg/__init__.py` contains `foo = 42`, then `from mypkg import foo` will not import the module
 *   `mypkg/foo.py` but the variable `foo` containing `42` -- however, `import mypkg.foo` will always cause `mypkg.foo`
 *   to refer to the module.
 */
deprecated Node importNode(string name) {
  exists(Variable var, Import imp, Alias alias |
    alias = imp.getAName() and
    alias.getAsname() = var.getAStore() and
    (
      name = alias.getValue().(ImportMember).getImportedModuleName()
      or
      name = alias.getValue().(ImportExpr).getImportedModuleName()
    ) and
    result.asExpr() = alias.getValue()
  )
  or
  // Although it may seem superfluous to consider the `foo` part of `from foo import bar as baz` to
  // be a reference to a module (since that reference only makes sense locally within the `import`
  // statement), it's important for our use of type trackers to consider this local reference to
  // also refer to the `foo` module. That way, if one wants to track references to the `bar`
  // attribute using a type tracker, one can simply write
  //
  // ```ql
  // DataFlow::Node bar_attr_tracker(TypeTracker t) {
  //   t.startInAttr("bar") and
  //   result = foo_module_tracker()
  //   or
  //   exists(TypeTracker t2 | result = bar_attr_tracker(t2).track(t2, t))
  // }
  // ```
  //
  // Where `foo_module_tracker` is a type tracker that tracks references to the `foo` module.
  // Because named imports are modelled as `AttrRead`s, the statement `from foo import bar as baz`
  // is interpreted as if it was an assignment `baz = foo.bar`, which means `baz` gets tracked as a
  // reference to `foo.bar`, as desired.
  exists(ImportExpr imp_expr |
    imp_expr.getName() = name and
    result.asCfgNode().getNode() = imp_expr and
    // in `import foo.bar` we DON'T want to give a result for `importNode("foo.bar")`,
    // only for `importNode("foo")`. We exclude those cases with the following clause.
    not exists(Import imp | imp.getAName().getValue() = imp_expr)
  )
}
