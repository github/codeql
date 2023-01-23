import ql
private import codeql_ql.ast.internal.AstNodes as AstNodes
private import codeql_ql.ast.internal.TreeSitter

private class ContainerOrModule extends TContainerOrModule {
  string getName() { none() }

  ContainerOrModule getEnclosing() { none() }

  string toString() { none() }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }

  /** Gets the kind of this file/module/folder. */
  string getKind() {
    this = TFile(_) and result = "file"
    or
    this = TModule(_) and result = "module"
    or
    this = TFolder(_) and result = "folder"
  }

  /** Gets the module for this imported module. */
  Module asModule() { this = TModule(result) }

  /** Gets the file for this file. */
  File asFile() { this = TFile(result) }
}

private class TFileOrModule = TFile or TModule;

/** A file or a module. */
class FileOrModule extends TFileOrModule, ContainerOrModule {
  /** Gets the file that contains this module/file. */
  File getFile() {
    result = this.asFile()
    or
    result = this.asModule().getLocation().getFile()
  }

  Type toType() {
    result.(FileType).getDeclaration().getLocation().getFile() = this.asFile()
    or
    result.(ModuleType).getDeclaration() = this.asModule()
  }
}

private class File_ extends FileOrModule, TFile {
  File f;

  File_() { this = TFile(f) }

  override ContainerOrModule getEnclosing() { result = TFolder(f.getParentContainer()) }

  override string getName() { result = f.getStem().replaceAll(" ", "_") }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    filepath = f.getAbsolutePath() and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }
}

private class Folder_ extends ContainerOrModule, TFolder {
  Folder f;

  Folder_() { this = TFolder(f) }

  override ContainerOrModule getEnclosing() {
    result = TFolder(f.getParentContainer()) and
    // if this the root, then we stop.
    not exists(f.getFile("qlpack.yml"))
  }

  override string getName() { result = f.getStem().replaceAll(" ", "_") }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    filepath = f.getAbsolutePath() and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  /**
   * Gets the folder that this IPA type represents.
   */
  Folder getFolder() { result = f }
}

class Module_ extends FileOrModule, TModule {
  Module m;

  Module_() { this = TModule(m) }

  override ContainerOrModule getEnclosing() { result = getEnclosingModule(m) }

  override string getName() { result = m.getName() }

  override string toString() { result = m.toString() }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    m.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private predicate resolveImportQualifier(Import imp, ContainerOrModule m, int i) {
  not m = TFile(any(File f | f.getExtension() = "ql")) and
  exists(string q | q = imp.getQualifiedName(i) |
    i = 0 and
    (
      exists(Container c, Container parent |
        // should ideally look at `qlpack.yml` files
        parent = pragma[only_bind_out](imp.getLocation()).getFile().getParentContainer+() and
        exists(YAML::QLPack pack |
          pack.getFile().getParentContainer() = parent and
          c.getParentContainer() = pack.getADependency*().getFile().getParentContainer()
        ) and
        q = m.getName()
      |
        m = TFile(c)
        or
        m = TFolder(c)
      )
      or
      exists(ContainerOrModule container | container = getEnclosingModule(imp).getEnclosing+() |
        definesModule(container, q, m, _) and
        (
          exists(container.(Folder_).getFolder().getFile("qlpack.yml")) or
          container.(Folder_).getFolder() =
            pragma[only_bind_out](imp.getLocation()).getFile().getParentContainer() or
          not container instanceof Folder_
        )
      )
      or
      definesModule(getEnclosingModule(imp), q, m, _)
    )
    or
    exists(Folder_ mid |
      resolveImportQualifier(imp, mid, i - 1) and
      m.getEnclosing() = mid and
      q = m.getName()
    )
  )
}

private predicate resolveImportQualifier(Import imp, ContainerOrModule m) {
  (m.(File_).getFile().getExtension() = "qll" or not m instanceof File_) and
  exists(int last |
    last = max(int j | exists(imp.getQualifiedName(j))) and
    resolveImportQualifier(imp, m, last)
  )
}

cached
private module Cached {
  private AstNode parent(AstNode n) {
    result = n.getParent() and
    not n instanceof Module
  }

  private Module getEnclosingModule0(AstNode n) { result = parent*(n.getParent()) }

  cached
  ContainerOrModule getEnclosingModule(AstNode n) {
    result = TModule(getEnclosingModule0(n))
    or
    not exists(getEnclosingModule0(n)) and
    result = TFile(n.getLocation().getFile())
  }

  cached
  module NewType {
    cached
    newtype TContainerOrModule =
      TFile(File f) or
      TFolder(Folder f) or
      TModule(Module m)
  }

  private import codeql_ql.ast.internal.Builtins as Builtins

  /** Holds if module expression `me` resolves to `m`. */
  cached
  predicate resolveModuleRef(TypeRef me, FileOrModule m) {
    // base case, resolving a typeref without a qualifier (only moduleexpr can have qualifiers)
    not m = TFile(any(File f | f.getExtension() = "ql")) and
    not exists(me.(ModuleExpr).getQualifier()) and
    exists(ContainerOrModule enclosing, string name | resolveModuleRefHelper(me, enclosing, name) |
      definesModule(enclosing, name, m, _)
    ) and
    (
      not me instanceof TypeExpr
      or
      // remove some spurious results that can happen with `TypeExpr`
      me instanceof TypeExpr and
      m instanceof Module_ and // TypeExpr can only resolve to a Module, and only in some scenarios
      (
        // only possible if this is inside a moduleInstantiation.
        me = any(ModuleExpr mod).getArgument(_).asType()
        or
        // or if it's a parameter to a parameterized module
        me = any(SignatureExpr sig, Module mod | mod.hasParameter(_, _, sig) | sig).asType()
      )
    )
    or
    // recursive case, resolving the qualifier.
    exists(FileOrModule mid |
      resolveModuleRef(me.(ModuleExpr).getQualifier(), mid) and
      definesModule(mid, me.(ModuleExpr).getName(), m, true)
    )
    or
    // The buildin `QlBuiltins` module, implemented as a mock AST node.
    me instanceof ModuleExpr and
    not exists(me.(ModuleExpr).getQualifier()) and
    me.(ModuleExpr).getName() = "QlBuiltins" and
    AstNodes::toMock(m.asModule()).getId() instanceof Builtins::QlBuiltinsMocks::QlBuiltinsModule
  }

  /**
   * Gets the module that the lookup for `ref` should start at.
   * For most type references this will simply be the enclosing module.
   *
   * However, for module expressions inside imports, this will be determined
   * by the qualified name of the import (everything before the module expression).
   *
   * E.g. for an import `import foo.Bar::Baz`, the qualified name of the import is "foo",
   * and the module expression is "Bar::Baz".
   */
  private ContainerOrModule getStartModule(TypeRef ref) {
    if isInsideImport(ref)
    then
      exists(Import i | ref = i.getModuleExpr().getQualifier*() |
        resolveImportQualifier(i, result)
        or
        not exists(i.getQualifiedName(_)) and
        (
          result = getEnclosingModule(ref)
          or
          exists(YAML::QLPack pack |
            pack.getAFileInPack() = ref.getLocation().getFile() and
            result = TFolder(pack.getADependency*().getFile().getParentContainer())
          )
        )
      )
    else result = getEnclosingModule(ref)
  }

  /** Holds of `me` is part of an import statement. */
  pragma[noinline]
  private predicate isInsideImport(ModuleExpr me) {
    me = any(Import i).getModuleExpr().getQualifier*()
  }

  /** Gets the enclosing module/container, but stops after the first folder (so no folder -> folder step). */
  private ContainerOrModule getEnclosingModuleNoFolderStep(ContainerOrModule m) {
    result = m.getEnclosing() and
    not (
      result instanceof Folder_ and
      m instanceof Folder_
    )
  }

  pragma[noinline]
  private predicate resolveModuleRefHelper(TypeRef me, ContainerOrModule enclosing, string name) {
    // The scope is all enclosing modules, the immediately containing folder, not the parent folders.
    enclosing = getEnclosingModuleNoFolderStep*(getStartModule(me)) and
    name = [me.(ModuleExpr).getName(), me.(TypeExpr).getClassName()] and
    not exists(me.(ModuleExpr).getQualifier()) and
    (
      // module expressions are not imports, so they can't resolve to a file (which is contained in a folder).
      (not me instanceof ModuleExpr or not enclosing instanceof Folder_)
      or
      isInsideImport(me) // unless it actually is an import.
    )
  }
}

import Cached
private import NewType

boolean getPublicBool(AstNode n) {
  if
    n.(ModuleMember).isPrivate() or
    n.(NewTypeBranch).getNewType().isPrivate() or
    n.(Module).isPrivate()
  then result = false
  else result = true
}

/**
 * Holds if `container` defines module `m` with name `name`.
 *
 * `m` may be defined either directly or through imports.
 */
private predicate definesModule(
  ContainerOrModule container, string name, ContainerOrModule m, boolean public
) {
  container = m.getEnclosing() and
  name = m.getName() and
  (
    (m instanceof File_ or m instanceof Folder_) and
    public = true
    or
    m = TModule(any(Module mod | public = getPublicBool(mod)))
  )
  or
  // signature module in a parameterized module
  exists(Module mod, SignatureExpr sig, TypeRef ty, int i |
    mod = container.asModule() and
    mod.hasParameter(i, name, sig) and
    public = false and
    ty = sig.asType()
  |
    // resolve to the signature module
    m = ty.getResolvedModule()
    or
    // resolve to the arguments of the instantiated module
    exists(ModuleExpr inst | inst.getResolvedModule().asModule() = mod |
      m = inst.getArgument(i).asType().getResolvedModule()
    )
  )
  or
  // import X
  exists(Import imp, ContainerOrModule m0 |
    container = getEnclosingModule(imp) and
    resolveModuleRef(imp.getModuleExpr(), m0) and
    not exists(imp.importedAs()) and
    definesModule(m0, name, m, true) and
    public = getPublicBool(imp)
  )
  or
  // import X as Y
  exists(Import imp |
    container = getEnclosingModule(imp) and
    name = imp.importedAs() and
    resolveModuleRef(imp.getModuleExpr(), m) and
    public = getPublicBool(imp)
  )
  or
  // module X = Y
  exists(Module alias |
    container = getEnclosingModule(alias) and
    name = alias.getName() and
    resolveModuleRef(alias.getAlias(), m) and
    public = getPublicBool(alias)
  )
}

module ModConsistency {
  // This can happen with parameterized modules.
  /*
   * query predicate multipleResolveModuleRef(ModuleExpr me, int c, ContainerOrModule m) {
   *    c = strictcount(ContainerOrModule m0 | resolveModuleRef(me, m0)) and
   *    c > 1 and
   *    resolveModuleRef(me, m)
   *  }
   */

  query predicate noName(AstNode mod) {
    mod instanceof Module and
    not exists(mod.(Module).getName())
    or
    mod instanceof ModuleExpr and
    not exists(mod.(ModuleExpr).getName())
  }

  query predicate nonUniqueName(AstNode mod) {
    mod instanceof Module and
    count(mod.(Module).getName()) >= 2
    or
    mod instanceof ModuleExpr and
    count(mod.(ModuleExpr).getName()) >= 2
  }

  query predicate uniqueResolve(Import i) {
    count(FileOrModule mod |
      mod = i.getResolvedModule() and
      // don't count the alias reference, only the resolved.
      not exists(mod.asModule().getAlias())
    ) >= 2 and
    // paramerized modules are not treated nicely, so we ignore them here.
    not i.getResolvedModule().getEnclosing*().asModule().hasParameter(_, _, _) and
    not i.getResolvedModule().asModule().hasAnnotation("signature") and
    not i.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }

  // not a query predicate, because this fails when running qltests, but it passes on the real thing (so it's used in EmptyConsistencies.ql)
  predicate noResolve(Import i) {
    not exists(i.getResolvedModule()) and
    not i.getLocation()
        .getFile()
        .getAbsolutePath()
        .regexpMatch(".*/(test|examples|ql-training|recorded-call-graph-metrics)/.*")
  }
}
