import python
import semmle.python.dependencies.DependencyKind

private predicate importDependency(Object target, AstNode source) {
  source.getScope() != target.getOrigin() and
  /* Imports of own module are ignored */
  (
    exists(ModuleObject importee, ImportingStmt imp_stmt |
      source = imp_stmt and
      importee = target
    |
      exists(ImportMember im | imp_stmt.contains(im) |
        importee.importedAs(im.getImportedModuleName())
      )
      or
      exists(ImportExpr im | imp_stmt.contains(im) |
        importee.importedAs(im.getImportedModuleName())
      )
      or
      exists(ModuleObject mod |
        importDependency(mod, source) and
        target = mod.getPackage+()
      )
    )
    or
    /* from m import name, where m.name is not a submodule */
    exists(PythonModuleObject importee, ImportingStmt imp_stmt | source = imp_stmt |
      exists(ImportMember im | imp_stmt.contains(im) |
        importee.importedAs(im.getModule().(ImportExpr).getImportedModuleName()) and
        defn_of_module_attribute(target, importee.getModule(), im.getName())
      )
    )
  )
}

class PythonImport extends DependencyKind {
  PythonImport() { this = "import" }

  override predicate isADependency(AstNode source, Object target) {
    this = this and
    importDependency(target, source)
  }
}

private predicate interesting(Object target) {
  target.(ControlFlowNode).getNode() instanceof Scope
  or
  target instanceof FunctionObject
  or
  target instanceof ClassObject
  or
  target instanceof ModuleObject
}

class PythonUse extends DependencyKind {
  PythonUse() { this = "use" }

  override predicate isADependency(AstNode source, Object target) {
    interesting(target) and
    this = this and
    source != target.(ControlFlowNode).getNode() and
    exists(ControlFlowNode use, Object obj |
      use.getNode() = source and
      use.refersTo(obj) and
      use.isLoad()
    |
      interesting(obj) and target = obj
    ) and
    not has_more_specific_dependency_source(source)
  }
}

/**
 * Whether there is a more specific dependency source than this one.
 * E.g. if the expression pack.mod.func is a dependency on the function 'func' in 'pack.mod'
 * don't make pack.mod depend on the module 'pack.mod'
 */
private predicate has_more_specific_dependency_source(Expr e) {
  exists(Attribute member | member.getObject() = e |
    attribute_access_dependency(_, member)
    or
    has_more_specific_dependency_source(member)
  )
}

class PythonInheritance extends DependencyKind {
  PythonInheritance() { this = "inheritance" }

  override predicate isADependency(AstNode source, Object target) {
    this = this and
    exists(ClassObject cls | source = cls.getOrigin() |
      target = cls.getASuperType()
      or
      target = cls.getAnInferredType()
    )
  }
}

class PythonAttribute extends DependencyKind {
  PythonAttribute() { this = "attribute" }

  override predicate isADependency(AstNode source, Object target) {
    this = this and
    attribute_access_dependency(target, source)
  }
}

private predicate attribute_access_dependency(Object target, AstNode source) {
  exists(Scope s, string name |
    use_of_attribute(source, s, name) and
    defn_of_attribute(target, s, name)
  )
}

private predicate use_of_attribute(Attribute attr, Scope s, string name) {
  exists(AttrNode cfg | cfg.isLoad() and cfg.getNode() = attr |
    exists(Object obj | cfg.getObject(name).refersTo(obj) |
      s = obj.(PythonModuleObject).getModule() or
      s = obj.(ClassObject).getPyClass()
    )
    or
    exists(ClassObject cls | cfg.getObject(name).refersTo(_, cls, _) | s = cls.getPyClass())
  )
  or
  exists(SelfAttributeRead sar | sar = attr |
    sar.getClass() = s and
    sar.getName() = name
  )
}

private predicate defn_of_attribute(Object target, Scope s, string name) {
  exists(Assign asgn | target.(ControlFlowNode).getNode() = asgn |
    defn_of_instance_attribute(asgn, s, name)
    or
    defn_of_class_attribute(asgn, s, name)
  )
  or
  defn_of_module_attribute(target, s, name)
}

/*
 * Whether asgn defines an instance attribute, that is does
 * asgn take the form  self.name  = ... where self is an instance
 * of class c and asgn is not a redefinition.
 */

private predicate defn_of_instance_attribute(Assign asgn, Class c, string name) {
  exists(SelfAttributeStore sas | asgn.getATarget() = sas |
    sas.getClass() = c and
    sas.getName() = name and
    not exists(SelfAttributeStore in_init |
      not sas.getScope().(Function).isInitMethod() and
      not sas = in_init and
      in_init.getClass() = c and
      in_init.getName() = name and
      in_init.getScope().(Function).isInitMethod()
    )
  )
}

/* Whether asgn defines an attribute of a class */
private predicate defn_of_class_attribute(Assign asgn, Class c, string name) {
  asgn.getScope() = c and
  asgn.getATarget().(Name).getId() = name
}

/* Holds if `value` is a value assigned to the `name`d attribute of module `m`. */
private predicate defn_of_module_attribute(ControlFlowNode value, Module m, string name) {
  exists(DefinitionNode def |
    def.getScope() = m and
    def.getValue() = value and
    def.(NameNode).getId() = name
  )
}
