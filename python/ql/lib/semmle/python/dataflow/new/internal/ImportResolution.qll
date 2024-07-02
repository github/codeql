/**
 * INTERNAL. DO NOT USE.
 *
 * Provides predicates for resolving imports.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.ImportStar
private import semmle.python.dataflow.new.TypeTracking
private import semmle.python.dataflow.new.internal.DataFlowPrivate

/**
 * Python modules and the way imports are resolved are... complicated. Here's a crash course in how
 * it works, as well as some caveats to bear in mind when looking at the implementation in this
 * module.
 *
 * First, let's consider the humble `import` statement:
 * ```python
 * import foo
 * import bar.baz
 * import ham.eggs as spam
 * ```
 *
 * In the AST, all imports are aliased, as in the last import above. That is, `import foo` becomes
 * `import foo as foo`, and `import bar.baz` becomes `import bar as bar`. Note that `import` is
 * exclusively used to import modules -- if `eggs` is an attribute of the `ham` module (and not a
 * submodule of the `ham` package), then the third line above is an error.
 *
 * Next, we have the `from` statement. This one is a bit more complicated, but still has the same
 * aliasing desugaring as above applied to it. Thus, `from foo import bar` becomes
 * `from foo import bar as bar`.
 *
 * In general, `from foo import bar` can mean two different things:
 *
 * 1. If `foo` is a module, and `bar` is an attribute of `foo`, then `from foo import bar` imports
 *    the attribute `bar` into the current module (binding it to the name `bar`).
 * 2. If `foo` is a package, and `bar` is already defined in `foo/__init__.py`,
 *    that value will be imported. If it is not defined, and `bar` is a submodule of `foo`, then
 *    `bar` is imported to `foo`, and the `bar` submodule imported.
 *    Note: We don't currently model if the attribute is already defined in `__init__.py`
 *    and always assume that the submodule will be used.
 *
 * Now, when it comes to how these imports are represented in the AST, things get a bit complicated.
 * First of all, both of the above forms of imports get mapped to the same kind of AST node:
 * `Import`. An `Import` node has a sequence of names, each of which is an `Alias` node. This `Alias`
 * node represents the `x as y` bit of each imported module.
 *
 * The same is true for `from` imports. So, how then do we distinguish between the two forms of
 * imports? The distinguishing feature is the left hand side of the `as` node. If the left hand side
 * is an `ImportExpr`, then it is a plain import. If it is an `ImportMember`, then it is a `from`
 * import. (And to confuse matters even more, this `ImportMember` contains another `ImportExpr` for
 * the bit between the `from` and `import` keywords.)
 *
 * Caveats:
 *
 * - A relative import of the form `from .foo import bar as baz` not only imports `bar` and binds it
 *   to the name `baz`, but also imports `foo` and binds it to the name `foo`. This only happens with
 *   relative imports. `from foo import bar as baz` only binds `bar` to `baz`.
 * - Modules may also be packages, so e.g. `import foo.bar` may import the `bar` submodule in the `foo`
 *   package, or the `bar` subpackage of the `foo` package. The practical difference here is the name of
 *   the module that is imported, as the package `foo.bar` will have the "name" `foo.bar.__init__`,
 *   corresponding to the fact that the code that is executed is in the `__init__.py` file of the
 *   `bar` subpackage.
 */
module ImportResolution {
  /**
   * Holds if there is an ESSA step from `defFrom` to `defTo`, which should be allowed
   * for import resolution.
   */
  private predicate allowedEssaImportStep(EssaDefinition defFrom, EssaDefinition defTo) {
    // to handle definitions guarded by if-then-else
    defFrom = defTo.(PhiFunction).getAnInput()
    or
    // refined variable
    // example: https://github.com/nvbn/thefuck/blob/ceeaeab94b5df5a4fe9d94d61e4f6b0bbea96378/thefuck/utils.py#L25-L45
    defFrom = defTo.(EssaNodeRefinement).getInput().getDefinition()
  }

  /**
   * Holds if the module `m` defines a name `name` with the value `val`. The value
   * represents the value `name` will have at the end of the module (the last place we
   * have def-use flow to).
   *
   * Note: The handling of re-exporting imports is a bit simplistic. We assume that if
   * an import is made, it will be re-exported (which will not be the case if a new
   * value is assigned to the name, or it is deleted).
   */
  pragma[nomagic]
  predicate module_export(Module m, string name, DataFlow::Node val) {
    // Definitions made inside `m` itself
    //
    // for code such as `foo = ...; foo.bar = ...` there will be TWO
    // EssaDefinition/EssaVariable. One for `foo = ...` (AssignmentDefinition) and one
    // for `foo.bar = ...`. The one for `foo.bar = ...` (EssaNodeRefinement). The
    // EssaNodeRefinement is the one that will reach the end of the module (normal
    // exit).
    //
    // However, we cannot just use the EssaNodeRefinement as the `val`, because the
    // normal data-flow depends on use-use flow, and use-use flow targets CFG nodes not
    // EssaNodes. So we need to go back from the EssaDefinition/EssaVariable that
    // reaches the end of the module, to the first definition of the variable, and then
    // track forwards using use-use flow to find a suitable CFG node that has flow into
    // it from use-use flow.
    exists(EssaVariable lastUseVar, EssaVariable firstDef |
      lastUseVar.getName() = name and
      // we ignore special variable $ introduced by our analysis (not used for anything)
      // we ignore special variable * introduced by `from <pkg> import *` -- TODO: understand why we even have this?
      not name in ["$", "*"] and
      lastUseVar.getAUse() = m.getANormalExit() and
      allowedEssaImportStep*(firstDef, lastUseVar) and
      not allowedEssaImportStep(_, firstDef)
    |
      not LocalFlow::defToFirstUse(firstDef, _) and
      val.asCfgNode() = firstDef.getDefinition().(EssaNodeDefinition).getDefiningNode()
      or
      exists(ControlFlowNode mid, ControlFlowNode end |
        LocalFlow::defToFirstUse(firstDef, mid) and
        LocalFlow::useToNextUse*(mid, end) and
        not LocalFlow::useToNextUse(end, _) and
        val.asCfgNode() = end
      )
    )
    or
    // re-exports from `from <pkg> import *`
    exists(Module importedFrom |
      importedFrom = ImportStar::getStarImported(m) and
      module_export(importedFrom, name, val) and
      potential_module_export(importedFrom, name)
    )
    or
    // re-exports from `import <pkg>` or `from <pkg> import <stuff>`
    exists(Alias a |
      val.asExpr() = a.getValue() and
      a.getAsname().(Name).getId() = name and
      val.getScope() = m
    )
  }

  /**
   * Holds if the module `m` explicitly exports the name `name` by listing it in `__all__`. Only
   * handles simple cases where we can statically tell that this is the case.
   */
  private predicate all_mentions_name(Module m, string name) {
    exists(DefinitionNode def, SequenceNode n |
      def.getValue() = n and
      def.(NameNode).getId() = "__all__" and
      def.getScope() = m and
      any(StringLiteral s | s.getText() = name) = n.getAnElement().getNode()
    )
  }

  /**
   * Holds if the module `m` either does not set `__all__` (and so implicitly exports anything that
   * doesn't start with an underscore), or sets `__all__` in a way that's too complicated for us to
   * handle (in which case we _also_ pretend that it just exports all such names).
   */
  private predicate no_or_complicated_all(Module m) {
    // No mention of `__all__` in the module
    not exists(DefinitionNode def | def.getScope() = m and def.(NameNode).getId() = "__all__")
    or
    // `__all__` is set to a non-sequence value
    exists(DefinitionNode def |
      def.(NameNode).getId() = "__all__" and
      def.getScope() = m and
      not def.getValue() instanceof SequenceNode
    )
    or
    // `__all__` is used in some way that doesn't involve storing a value in it. This usually means
    // it is being mutated through `append` or `extend`, which we don't handle.
    exists(NameNode n | n.getId() = "__all__" and n.getScope() = m and n.isLoad())
  }

  private predicate potential_module_export(Module m, string name) {
    all_mentions_name(m, name)
    or
    no_or_complicated_all(m) and
    (
      exists(NameNode n | n.getId() = name and n.getScope() = m and name.charAt(0) != "_")
      or
      exists(Alias a | a.getAsname().(Name).getId() = name and a.getValue().getScope() = m)
    )
  }

  /**
   * Holds if the module `reexporter` exports the module `reexported` under the name
   * `reexported_name`.
   */
  private predicate module_reexport(Module reexporter, string reexported_name, Module reexported) {
    exists(DataFlow::Node ref |
      ref = getImmediateModuleReference(reexported) and
      module_export(reexporter, reexported_name, ref) and
      potential_module_export(reexporter, reexported_name)
    )
  }

  /**
   * Gets a reference to `sys.modules`.
   */
  private DataFlow::Node sys_modules_reference() {
    result =
      any(DataFlow::AttrRef a |
        a.getAttributeName() = "modules" and a.getObject().asExpr().(Name).getId() = "sys"
      )
  }

  /** Gets a module that may have been added to `sys.modules`. */
  private Module sys_modules_module_with_name(string name) {
    exists(ControlFlowNode n, DataFlow::Node mod |
      exists(SubscriptNode sub |
        sub.getObject() = sys_modules_reference().asCfgNode() and
        sub.getIndex() = n and
        n.getNode().(StringLiteral).getText() = name and
        sub.(DefinitionNode).getValue() = mod.asCfgNode() and
        mod = getModuleReference(result)
      )
    )
  }

  /**
   * Gets the (most likely) module for the name `name`, if any.
   *
   * Handles the fact that for the name `<pkg>` representing a package the actual module
   * is `<pkg>.__init__`.
   *
   * See `isPreferredModuleForName` for more details on what "most likely" module means.
   */
  pragma[inline]
  private Module getModuleFromName(string name) {
    isPreferredModuleForName(result.getFile(), [name, name + ".__init__"])
  }

  /** Gets the module from which attributes are imported by `i`. */
  Module getModuleImportedByImportStar(ImportStar i) {
    result = getModuleFromName(i.getImportedModuleName())
  }

  /**
   * Gets a data-flow node that may be a reference to a module with the name `module_name`.
   *
   * This is a helper predicate for `getImmediateModuleReference`. It captures the fact that in an
   * import such as `import foo`,
   * - `foo` may simply be the name of a module, or
   * - `foo` may be the name of a package (in which case its name is actually `foo.__init__`), or
   * - `foo` may be a module name that has been added to `sys.modules` (in which case its actual name can
   *   be anything, for instance `os.path` is either `posixpath` or `ntpath`).
   */
  private DataFlow::Node getReferenceToModuleName(string module_name) {
    // Regular import statements, e.g.
    // import foo    # implicitly `import foo as foo`
    // import foo as foo_alias
    exists(Import i, Alias a | a = i.getAName() |
      result.asExpr() = a.getAsname() and
      module_name = a.getValue().(ImportExpr).getImportedModuleName()
    )
    or
    // The module part of a `from ... import ...` statement, e.g. the `..foo.bar` in
    // from ..foo.bar import baz    # ..foo.bar might point to, say, package.subpackage.foo.bar
    exists(ImportMember i | result.asExpr() = i.getModule() |
      module_name = i.getModule().(ImportExpr).getImportedModuleName()
    )
    or
    // Modules (not attributes) imported via `from ... import ... statements`, e.g.
    // from foo.bar import baz    # imports foo.bar.baz as baz
    // from foo.bar import baz as baz_alias    # imports foo.bar.baz as baz_alias
    exists(Import i, Alias a, ImportMember im | a = i.getAName() and im = a.getValue() |
      result.asExpr() = a.getAsname() and
      module_name = im.getModule().(ImportExpr).getImportedModuleName() + "." + im.getName()
    )
    or
    // For parity with the points-to based solution, the `ImportExpr` and `ImportMember` bits of the
    // above cases should _also_ point to the right modules.
    result.asExpr() = any(ImportExpr i | i.getImportedModuleName() = module_name)
    or
    result.asExpr() =
      any(ImportMember i |
        i.getModule().(ImportExpr).getImportedModuleName() + "." + i.getName() = module_name
      )
  }

  /** Join-order helper for `getImmediateModuleReference`. */
  pragma[nomagic]
  private predicate module_reference_accesses(DataFlow::AttrRead ar, Module p, string attr_name) {
    ar.accesses(getModuleReference(p), attr_name)
  }

  /**
   * Gets a dataflow node that is an immediate reference to the module `m`.
   *
   * Because of attribute lookups, this is mutually recursive with `getModuleReference`.
   */
  DataFlow::Node getImmediateModuleReference(Module m) {
    exists(string module_name | result = getReferenceToModuleName(module_name) |
      // Depending on whether the referenced module is a package or not, we may need to add a
      // trailing `.__init__` to the module name.
      m = getModuleFromName(module_name)
      or
      // Module defined via `sys.modules`
      m = sys_modules_module_with_name(module_name)
    )
    or
    // Reading an attribute on a module may return a submodule (or subpackage).
    exists(Module p, string attr_name | module_reference_accesses(result, p, attr_name) |
      m = getModuleFromName(p.getPackageName() + "." + attr_name)
    )
    or
    // This is also true for attributes that come from reexports.
    exists(Module reexporter, string attr_name |
      module_reference_accesses(result, reexporter, attr_name) and
      module_reexport(reexporter, attr_name, m)
    )
    or
    // submodules of packages will be available as `<pkg>.<submodule>` after doing
    // `import <pkg>.<submodule>` at least once in the program, or can be directly
    // imported with `from <pkg> import <submodule>` (even with an empty
    // `<pkg>.__init__` file).
    //
    // Until an import of `<pkg>.<submodule>` is executed, it is technically possible
    // that `<pkg>.<submodule>` (or `from <pkg> import <submodule>`) can refer to an
    // attribute set in `<pkg>.__init__`.
    //
    // Therefore, if there is an attribute defined in `<pkg>.__init__` with the same
    // name as a submodule, we always consider that this attribute _could_ be a
    // reference to the submodule, even if we don't know that the submodule has been
    // imported yet.
    exists(string submodule, Module package, EssaVariable var |
      submodule = var.getName() and
      SsaSource::init_module_submodule_defn(var.getSourceVariable(), package.getEntryNode()) and
      m = getModuleFromName(package.getPackageName() + "." + submodule) and
      result.asCfgNode() = var.getDefinition().(EssaNodeDefinition).getDefiningNode()
    )
  }

  /** Join-order helper for `getModuleReference`. */
  pragma[nomagic]
  private predicate module_reference_in_scope(DataFlow::Node node, Scope s, string name, Module m) {
    node.getScope() = s and
    node.asExpr().(Name).getId() = name and
    pragma[only_bind_into](node) = getImmediateModuleReference(pragma[only_bind_into](m))
  }

  /** Join-order helper for `getModuleReference`. */
  pragma[nomagic]
  private predicate module_name_in_scope(DataFlow::Node node, Scope s, string name) {
    node.getScope() = s and
    exists(Name n | n = node.asExpr() |
      n.getId() = name and
      pragma[only_bind_into](n).isUse()
    )
  }

  /**
   * Gets a reference to the module `m` (including through certain kinds of local and global flow).
   */
  DataFlow::Node getModuleReference(Module m) {
    // Immedate references to the module
    result = getImmediateModuleReference(m)
    or
    // Flow (local or global) forward to a later reference to the module.
    exists(DataFlow::Node ref | ref = getModuleReference(m) |
      simpleLocalFlowStepForTypetracking(ref, result)
      or
      exists(DataFlow::ModuleVariableNode mv |
        mv.getAWrite() = ref and
        result = mv.getARead()
      )
    )
    or
    // A reference to a name that is bound to a module in an enclosing scope.
    exists(DataFlow::Node def, Scope def_scope, Scope use_scope, string name |
      module_reference_in_scope(pragma[only_bind_into](def), pragma[only_bind_into](def_scope),
        pragma[only_bind_into](name), pragma[only_bind_into](m)) and
      module_name_in_scope(result, use_scope, name) and
      use_scope.getEnclosingScope*() = def_scope
    )
  }

  Module getModule(DataFlow::CfgNode node) { node = getModuleReference(result) }
}
