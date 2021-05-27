import ql
private import codeql_ql.ast.internal.AstNodes as AstNodes
private import codeql_ql.ast.internal.TreeSitter

private newtype TContainerOrModule =
  TFile(File f) or
  TFolder(Folder f) or
  TModule(Module m)

private class ContainerOrModule extends TContainerOrModule {
  string getName() { none() }

  ContainerOrModule getEnclosing() { none() }

  string toString() { none() }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    none()
  }
}

private class TFileOrModule = TFile or TModule;

/** A file or a module. */
class FileOrModule extends TFileOrModule, ContainerOrModule { }

private class File_ extends FileOrModule, TFile {
  File f;

  File_() { this = TFile(f) }

  override ContainerOrModule getEnclosing() { result = TFolder(f.getParentContainer()) }

  override string getName() { result = f.getStem() }

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

  override ContainerOrModule getEnclosing() { result = TFolder(f.getParentContainer()) }

  override string getName() { result = f.getStem() }

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

// TODO: Use `AstNode::getParent` once it is total
private Generated::AstNode parent(Generated::AstNode n) {
  result = n.getParent() and
  not n instanceof Generated::Module
}

private Module getEnclosingModule0(AstNode n) {
  AstNodes::toGenerated(result) = parent*(AstNodes::toGenerated(n).getParent())
}

ContainerOrModule getEnclosingModule(AstNode n) {
  result = TModule(getEnclosingModule0(n))
  or
  not exists(getEnclosingModule0(n)) and
  result = TFile(n.getLocation().getFile())
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

private predicate resolveQualifiedName(Import imp, ContainerOrModule m, int i) {
  not m = TFile(any(File f | f.getExtension() = "ql")) and
  exists(string q | q = imp.getQualifiedName(i) |
    i = 0 and
    (
      exists(Container c, Container parent |
        // should ideally look at `qlpack.yml` files
        parent = imp.getLocation().getFile().getParentContainer+() and
        c.getParentContainer() = parent and
        q = m.getName()
      |
        m = TFile(c)
        or
        m = TFolder(c)
      )
      or
      defines(getEnclosingModule(imp).getEnclosing*(), q, m, _)
    )
    or
    exists(Folder_ mid |
      resolveQualifiedName(imp, mid, i - 1) and
      m.getEnclosing() = mid and
      q = m.getName()
    )
  )
}

private predicate resolveSelectionName(Import imp, ContainerOrModule m, int i) {
  exists(int last |
    resolveQualifiedName(imp, m, last) and
    last = count(int j | exists(imp.getQualifiedName(j))) - 1
  ) and
  not m instanceof Folder_ and
  i = -1
  or
  exists(ContainerOrModule mid |
    resolveSelectionName(imp, mid, i - 1) and
    defines(mid, imp.getSelectionName(i), m, true)
  )
}

/** Holds if import statement `imp` resolves to `m`. */
predicate resolve(Import imp, FileOrModule m) {
  exists(int last |
    resolveSelectionName(imp, m, last) and
    last = count(int j | exists(imp.getSelectionName(j))) - 1
  )
}

/** Holds if module expression `me` resolves to `m`. */
predicate resolveModuleExpr(ModuleExpr me, FileOrModule m) {
  not m = TFile(any(File f | f.getExtension() = "ql")) and
  not exists(me.getQualifier()) and
  defines(getEnclosingModule(me).getEnclosing*(), me.getName(), m, _)
  or
  exists(FileOrModule mid |
    resolveModuleExpr(me.getQualifier(), mid) and
    defines(mid, me.getName(), m, true)
  )
}

private boolean getPublicBool(ModuleMember m) {
  if m.isPrivate() then result = false else result = true
}

/** Holds if `container` defines module `m` with name `name`. */
private predicate defines(
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
  // import X
  exists(Import imp, ContainerOrModule m0 |
    container = getEnclosingModule(imp) and
    resolve(imp, m0) and
    not exists(imp.importedAs()) and
    defines(m0, name, m, true) and
    public = getPublicBool(imp)
  )
  or
  // import X as Y
  exists(Import imp |
    container = getEnclosingModule(imp) and
    name = imp.importedAs() and
    resolve(imp, m) and
    public = getPublicBool(imp)
  )
  or
  // module X = Y
  exists(Module alias |
    container = getEnclosingModule(alias) and
    name = alias.getName() and
    resolveModuleExpr(alias.getAlias(), m) and
    public = getPublicBool(alias)
  )
}

module ModConsistency {
  query predicate noResolve(Import imp) {
    not resolve(imp, _) and
    not imp.getLocation().getFile().getAbsolutePath().regexpMatch(".*/(test|examples)/.*")
  }

  query predicate noResolveModuleExpr(ModuleExpr me) {
    not resolveModuleExpr(me, _) and
    not me.getLocation().getFile().getAbsolutePath().regexpMatch(".*/(test|examples)/.*")
  }

  query predicate multipleResolve(Import imp, int c, ContainerOrModule m) {
    c = strictcount(ContainerOrModule m0 | resolve(imp, m0)) and
    c > 1 and
    resolve(imp, m)
  }

  query predicate multipleResolveModuleExpr(ModuleExpr me, int c, ContainerOrModule m) {
    c = strictcount(ContainerOrModule m0 | resolveModuleExpr(me, m0)) and
    c > 1 and
    resolveModuleExpr(me, m)
  }
}
