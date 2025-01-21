/**
 * Provides classes for working with file system paths and program expressions
 * that denote them.
 */

import javascript
private import semmle.javascript.dataflow.internal.DataFlowNode

/**
 * Internal representation of paths as lists of components.
 */
private newtype TPath =
  /** A root path. */
  TRootPath(string root) {
    root = any(Folder f | not exists(f.getParentContainer())).getAbsolutePath()
  } or
  /** A path of the form `<parent>/<component>`. */
  TConsPath(Path parent, string component) {
    // make sure we can represent paths of files in snapshot
    exists(Folder f | f = parent.getContainer() | exists(f.getChildContainer(component)))
    or
    // make sure we can resolve path strings
    exists(PathString p, int n |
      p.resolveUpTo(n, _) = parent and
      p.getComponent(n) = component and
      // the empty string, `.` and `..` are not valid path components
      not component.regexpMatch("\\.{0,2}")
    )
  }

/**
 * Gets a textual representation of path `p` using slashes as delimiters;
 * the empty path is represented as the empty string `""`.
 */
private string pp(TPath p) {
  p = TRootPath(result + "/")
  or
  exists(TPath parent, string component | p = TConsPath(parent, component) |
    result = pp(parent) + "/" + component
  )
}

/**
 * An absolute file system path referenced in the program,
 * which may (but does not have to) correspond to a file or folder included
 * in the snapshot.
 */
class Path extends TPath {
  /**
   * Gets the file or folder referred to by this path, if it exists.
   */
  Container getContainer() { result.getAbsolutePath() = this.toString() }

  /**
   * Gets a textual representation of the path, using slashes as delimiters.
   */
  abstract string toString();
}

/**
 * The empty path, which refers to the file system root.
 */
private class RootPath extends Path, TRootPath {
  override string toString() { this = TRootPath(result) }
}

/**
 * A non-empty path of the form `<parent>/<component>`.
 */
private class ConsPath extends Path, TConsPath {
  /** Gets the parent path of this path. */
  Path getParent() { this = TConsPath(result, _) }

  /** Gets the last component of this path. */
  string getComponent() { this = TConsPath(_, result) }

  override string toString() { result = pp(this) }
}

/**
 * Gets a regular expression that can be used to parse slash-separated paths.
 *
 * The first capture group captures the dirname of the path, that is, everything
 * before the last slash, or the empty string if there isn't a slash.
 *
 * The second capture group captures the basename of the path, that is, everything
 * after the last slash, or the entire path if there isn't a slash.
 *
 * The third capture group captures the stem of the basename, that is, everything
 * before the last dot, or the entire basename if there isn't a dot.
 *
 * Finally, the fourth and fifth capture groups capture the extension of the basename,
 * that is, everything after the last dot. The fourth group includes the dot, the
 * fifth does not.
 */
private string pathRegex() { result = "(.*)(?:/|^)(([^/]*?)(\\.([^.]*))?)" }

/**
 * A string value that represents a (relative or absolute) file system path.
 *
 * Each path string is associated with one or more root folders relative to
 * which the path may be resolved. For instance, paths inside a module are
 * usually resolved relative to the module's folder, with a default
 * lookup path as the fallback.
 */
abstract class PathString extends string {
  bindingset[this]
  PathString() { any() }

  /** Gets a root folder relative to which this path can be resolved. */
  abstract Folder getARootFolder();

  /** Gets the `i`th component of this path. */
  string getComponent(int i) { result = this.splitAt("/", i) }

  /** Gets the number of components of this path. */
  int getNumComponent() { result = count(int i | exists(this.getComponent(i))) }

  /** Gets the base name of the folder or file this path refers to. */
  string getBaseName() { result = this.regexpCapture(pathRegex(), 2) }

  /**
   * Gets stem of the folder or file this path refers to, that is, the prefix of its base name
   * up to (but not including) the last dot character if there is one, or the entire
   * base name if there is not
   */
  string getStem() { result = this.regexpCapture(pathRegex(), 3) }

  /** Gets the path of the parent folder of the folder or file this path refers to. */
  string getDirName() { result = this.regexpCapture(pathRegex(), 1) }

  /**
   * Gets the extension of the folder or file this path refers to, that is, the suffix of the base name
   * starting at the last dot character, if there is one.
   *
   * Has no result if the base name does not contain a dot.
   */
  string getExtension() { result = this.regexpCapture(pathRegex(), 4) }

  /**
   * Gets the absolute path that the sub-path consisting of the first `n`
   * components of this path refers to when resolved relative to the
   * given `root` folder.
   */
  Path resolveUpTo(int n, Folder root) { result = resolveUpTo(this, n, root, _) }

  /**
   * Gets the absolute path that this path refers to when resolved relative to
   * `root`.
   */
  Path resolve(Folder root) { result = this.resolveUpTo(this.getNumComponent(), root) }
}

/**
 * Gets the absolute path that the sub-path consisting of the first `n`
 * components of this path refers to when resolved relative to the
 * given `root` folder.
 */
private Path resolveUpTo(PathString p, int n, Folder root, boolean inTS) {
  n = 0 and result.getContainer() = root and root = p.getARootFolder() and inTS = false
  or
  exists(Path base, string next | next = getComponent(p, n - 1, base, root, inTS) |
    // handle empty components and the special "." folder
    (next = "" or next = ".") and
    result = base
    or
    // handle the special ".." folder
    next = ".." and result = base.(ConsPath).getParent()
    or
    // special handling for Windows drive letters when resolving absolute path:
    // the extractor populates "C:/" as a folder that has path "C:/" but name ""
    n = 1 and
    next.regexpMatch("[A-Za-z]:") and
    root.getBaseName() = "" and
    root.toString() = next.toUpperCase() + "/" and
    result = base
    or
    // default case
    result = TConsPath(base, next)
  )
}

/**
 * Gets the `n`th component of the path `str`, where `base` is the resolved path one level up.
 * Supports that the root directory might be compiled output from TypeScript.
 * `inTS` is true if the result is TypeScript that is compiled into the path specified by `str`.
 */
private string getComponent(PathString str, int n, Path base, Folder root, boolean inTS) {
  exists(boolean prevTS |
    base = resolveUpTo(str, n, root, prevTS) and
    (
      result = str.getComponent(n) and prevTS = inTS
      or
      // If we are in a TypeScript source folder, try to replace file endings with ".ts" or ".tsx"
      n = str.getNumComponent() - 1 and
      prevTS = true and
      inTS = prevTS and
      result = str.getComponent(n).regexpCapture("^(.*)\\.js$", 1) + "." + ["ts", "tsx"]
      or
      prevTS = false and
      inTS = true and
      result =
        TypeScriptOutDir::getOriginalTypeScriptFolder(str.getComponent(n), base.getContainer())
    )
  )
}

/**
 * Predicates for resolving imports to compiled TypeScript.
 */
private module TypeScriptOutDir {
  /**
   * Gets a folder of TypeScript files that is compiled to JavaScript files in `outdir` relative to a `parent`.
   */
  string getOriginalTypeScriptFolder(string outdir, Folder parent) {
    exists(JsonObject tsconfig |
      outdir = removeLeadingSlash(getOutDir(tsconfig, parent)) and
      result = removeLeadingSlash(getEffectiveRootDirFromTSConfig(tsconfig))
    )
  }

  /**
   * Removes a leading dot and/or slash from `raw`.
   */
  bindingset[raw]
  private string removeLeadingSlash(string raw) {
    result = raw.regexpCapture("^\\.?/?([\\w.\\-]+)$", 1)
  }

  /**
   * Gets the "outDir" option from a `tsconfig` file from the folder `parent`.
   */
  private string getOutDir(JsonObject tsconfig, Folder parent) {
    tsconfig.getFile().getBaseName().regexpMatch("tsconfig.*\\.json") and
    tsconfig.isTopLevel() and
    tsconfig.getFile().getParentContainer() = parent and
    result = tsconfig.getPropValue("compilerOptions").getPropValue("outDir").getStringValue()
  }

  /**
   * Gets the directory that contains the TypeScript source files.
   * Based on the tsconfig.json file `tsconfig`.
   */
  pragma[inline]
  private string getEffectiveRootDirFromTSConfig(JsonObject tsconfig) {
    // if an explicit "rootDir" option exists, then use that.
    result = getRootDir(tsconfig)
    or
    // otherwise, infer from "includes"
    not exists(getRootDir(tsconfig)) and
    (
      // if unique root folder in "includes", then use that.
      result = unique( | | getARootDirFromInclude(tsconfig))
      or
      // otherwise use "." if the includes are split over multiple folders.
      exists(getARootDirFromInclude(tsconfig)) and
      not exists(unique( | | getARootDirFromInclude(tsconfig))) and
      result = "."
    )
  }

  /**
   * Gets the first folder from `path`.
   */
  bindingset[path]
  private string getRootFolderFromPath(string path) {
    not exists(path.indexOf("/")) and result = path
    or
    result = path.substring(0, path.indexOf("/", 0, 0))
  }

  /**
   * Gets a root directory containing TypeScript files based on the "include" option from tsconfig.json.
   * Can have multiple results if the includes are from multiple folders.
   */
  pragma[inline]
  private string getARootDirFromInclude(JsonObject tsconfig) {
    result =
      getRootFolderFromPath(tsconfig.getPropValue("include").getElementValue(_).getStringValue())
  }

  /**
   * Gets the value of the "rootDir" option from a tsconfig.json.
   */
  pragma[inline]
  private string getRootDir(JsonObject tsconfig) {
    result = tsconfig.getPropValue("compilerOptions").getPropValue("rootDir").getStringValue()
  }
}

/**
 * An expression whose value represents a (relative or absolute) file system path.
 *
 * Each path expression is associated with one or more root folders, each of which
 * has a priority. Root folders with numerically smaller properties are preferred,
 * meaning that a path expression is interpreted relative to the root folder with
 * the smallest priority for which the path can be resolved.
 *
 * For example, path expressions inside a module may have that module's folder
 * as their highest-priority root, with default library paths as additional roots
 * of lower priority.
 */
abstract class PathExpr extends Locatable {
  /** Gets the (unresolved) path represented by this expression. */
  abstract string getValue();

  /** Gets the root folder of priority `priority` associated with this path expression. */
  Folder getSearchRoot(int priority) {
    // We default to the enclosing module's search root, though this may be overridden.
    this.getEnclosingModule().searchRoot(this, result, priority)
    or
    result = this.getAdditionalSearchRoot(priority)
  }

  /**
   * INTERNAL. Use `getSearchRoot` instead.
   *
   * Can be overridden by subclasses of `PathExpr` to provide additional search roots
   * without overriding `getSearchRoot`.
   */
  Folder getAdditionalSearchRoot(int priority) { none() }

  /** Gets the `i`th component of this path. */
  string getComponent(int i) { result = this.getValue().(PathString).getComponent(i) }

  /** Gets the number of components of this path. */
  int getNumComponent() { result = this.getValue().(PathString).getNumComponent() }

  /** Gets the base name of the folder or file this path refers to. */
  string getBaseName() { result = this.getValue().(PathString).getBaseName() }

  /** Gets the stem, that is, base name without extension, of the folder or file this path refers to. */
  string getStem() { result = this.getValue().(PathString).getStem() }

  /**
   * Gets the extension of the folder or file this path refers to, that is, the suffix of the base name
   * starting at the last dot character, if there is one.
   *
   * Has no result if the base name does not contain a dot.
   */
  string getExtension() { result = this.getValue().(PathString).getExtension() }

  /**
   * Gets the file or folder that the first `n` components of this path refer to
   * when resolved relative to the root folder of the given `priority`.
   */
  pragma[nomagic]
  Container resolveUpTo(int n, int priority) {
    result =
      this.getValue().(PathString).resolveUpTo(n, this.getSearchRoot(priority)).getContainer()
  }

  /**
   * Gets the file or folder that this path refers to when resolved relative to
   * the root folder of the given `priority`.
   */
  Container resolve(int priority) { result = this.resolveUpTo(this.getNumComponent(), priority) }

  /**
   * Gets the file or folder that the first `n` components of this path refer to.
   */
  Container resolveUpTo(int n) {
    result = this.resolveUpTo(n, min(int p | exists(this.resolveUpTo(n, p))))
  }

  /** Gets the file or folder that this path refers to. */
  Container resolve() { result = this.resolveUpTo(this.getNumComponent()) }

  /** Gets the module containing this path expression, if any. */
  Module getEnclosingModule() {
    result = this.(Expr).getTopLevel() or result = this.(Comment).getTopLevel()
  }
}

/** A path string derived from a path expression. */
private class PathExprString extends PathString {
  PathExprString() { this = any(PathExpr pe).getValue() }

  override Folder getARootFolder() {
    result = any(PathExpr pe | this = pe.getValue()).getSearchRoot(_)
  }
}

pragma[nomagic]
private EarlyStageNode getAPathExprAlias(PathExpr expr) {
  DataFlow::Impl::earlyStageImmediateFlowStep(TValueNode(expr), result)
  or
  DataFlow::Impl::earlyStageImmediateFlowStep(getAPathExprAlias(expr), result)
}

private class PathExprFromAlias extends PathExpr {
  private PathExpr other;

  PathExprFromAlias() { TValueNode(this) = getAPathExprAlias(other) }

  override string getValue() { result = other.getValue() }

  override Folder getAdditionalSearchRoot(int priority) {
    result = other.getAdditionalSearchRoot(priority)
  }
}

/**
 * A path expression of the form `p + q`, where both `p` and `q`
 * are path expressions.
 */
private class ConcatPath extends PathExpr {
  ConcatPath() {
    exists(AddExpr add | this = add |
      add.getLeftOperand() instanceof PathExpr and
      add.getRightOperand() instanceof PathExpr
    )
  }

  override string getValue() {
    exists(AddExpr add, PathExpr left, PathExpr right |
      this = add and
      left = add.getLeftOperand() and
      right = add.getRightOperand()
    |
      result = left.getValue() + right.getValue()
    )
  }

  override Folder getAdditionalSearchRoot(int priority) {
    result = this.(AddExpr).getAnOperand().(PathExpr).getAdditionalSearchRoot(priority)
  }
}

/**
 * An expression that appears in a syntactic position where it may represent a path.
 *
 * Examples include arguments to the CommonJS `require` function or AMD dependency arguments.
 */
abstract class PathExprCandidate extends Expr {
  pragma[nomagic]
  private Expr getAPart1() { result = this or result = this.getAPart().getAChildExpr() }

  private EarlyStageNode getAnAliasedPart1() {
    result = TValueNode(this.getAPart1())
    or
    DataFlow::Impl::earlyStageImmediateFlowStep(result, this.getAnAliasedPart1())
  }

  /**
   * Gets an expression that is depended on by an expression nested inside this expression.
   */
  pragma[nomagic]
  Expr getAPart() { TValueNode(result) = this.getAnAliasedPart1() }
}
