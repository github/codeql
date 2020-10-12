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
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Gets an EssaNode that holds the module imported by `name`.
 * Note that for the statement `import pkg.mod`, the new variable introduced is `pkg` that is a
 * reference to the module `pkg`.
 *
 * This predicate handles (with optional `... as <new-name>`):
 * 1. `import <name>`
 * 2. `from <package> import <module>` when `<name> = <package> + "." + <module>`
 * 3. `from <module> import <member>` when `<name> = <module> + "." + <member>`
 *
 * Note:
 * While it is technically possible that `import mypkg.foo` and `from mypkg import foo` can give different values,
 * it's highly unlikely that this will be a problem in production level code.
 *   Example: If `mypkg/__init__.py` contains `foo = 42`, then `from mypkg import foo` will not import the module
 *   `mypkg/foo.py` but the variable `foo` containing `42` -- however, `import mypkg.foo` will always cause `mypkg.foo`
 *   to refer to the module.
 *
 * Also see `DataFlow::importMember`
 */
EssaNode importModule(string name) {
  exists(Variable var, Import imp, Alias alias |
    alias = imp.getAName() and
    alias.getAsname() = var.getAStore() and
    (
      name = alias.getValue().(ImportMember).getImportedModuleName()
      or
      name = alias.getValue().(ImportExpr).getImportedModuleName()
    ) and
    result.getVar().(AssignmentDefinition).getSourceVariable() = var
  )
}

/**
 * Gets a EssaNode that holds the value imported by using fully qualified name in
 *`from <moduleName> import <memberName>`.
 *
 * Also see `DataFlow::importModule`.
 */
EssaNode importMember(string moduleName, string memberName) {
  exists(Variable var, Import imp, Alias alias, ImportMember member |
    alias = imp.getAName() and
    member = alias.getValue() and
    moduleName = member.getModule().(ImportExpr).getImportedModuleName() and
    memberName = member.getName() and
    alias.getAsname() = var.getAStore() and
    result.getVar().(AssignmentDefinition).getSourceVariable() = var
  )
}
