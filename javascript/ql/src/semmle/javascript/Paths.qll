/**
 * Provides classes for working with file system paths and program expressions
 * that denote them.
 */

import javascript

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
  int getNumComponent() { result = count(int i | exists(getComponent(i))) }

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
  Path resolve(Folder root) { result = resolveUpTo(getNumComponent(), root) }
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
 * Gets the `i`th component of the path `str`, where `base` is the resolved path one level up.
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
        TypeScriptFileMapping::getOriginalTypeScriptFolder(str.getComponent(n), base.getContainer())
    )
  )
}

/**
 * Predicates for resolving imports based on the contents of `tsconfig.json`.
 */
private module TypeScriptFileMapping {
  /**
   * Gets a folder of TypeScript files that is compiled to JavaScript files in `outdir` relative to a `parent`.
   */
  string getOriginalTypeScriptFolder(string outdir, Folder parent) {
    exists(JSONObject tsconfig |
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
   * Gets the `outDir` option from a tsconfig file from the folder `parent`.
   */
  private string getOutDir(JSONObject tsconfig, Folder parent) {
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
  private string getEffectiveRootDirFromTSConfig(JSONObject tsconfig) {
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
  private string getARootDirFromInclude(JSONObject tsconfig) {
    result =
      getRootFolderFromPath(tsconfig.getPropValue("include").getElementValue(_).getStringValue())
  }

  /**
   * Gets the value of the "rootDir" option from a tsconfig.json.
   */
  pragma[inline]
  private string getRootDir(JSONObject tsconfig) {
    result = tsconfig.getPropValue("compilerOptions").getPropValue("rootDir").getStringValue()
  }

  /** Holds if the given `tsconfig.json` object has a `paths` mapping from `pattern` to `target`. */
  pragma[noinline]
  private predicate hasPathMapping(JSONObject tsconfig, string pattern, string target) {
    tsconfig
        .getPropValue("compilerOptions")
        .getPropValue("paths")
        .getPropValue(pattern)
        .getElementValue(_)
        .getStringValue() = target
  }

  /**
   * Gets the `baseUrl` value of the given `tsconfig`, if it exists.
   *
   * Note that this property is required for `"paths"` to work, so there is no
   * fallback value if it is omitted.
   */
  pragma[noinline]
  private string getBaseUrl(JSONObject tsconfig) {
    result = tsconfig.getPropValue("compilerOptions").getPropValue("baseUrl").getStringValue()
  }

  /**
   * Gets the directory referred to by the `baseUrl` of the given `tsconfig`.
   */
  pragma[noinline]
  private Folder getBaseUrlFolder(JSONObject tsconfig) {
    exists(string dirname |
      dirname = getBaseUrl(tsconfig).replaceAll("\\", "/") and
      result.getRelativePath() =
        (tsconfig.getFile().getParentContainer().getRelativePath() + "/" + dirname)
            .regexpReplaceAll("/\\.?(?=$|/)", "")
    )
  }

  /** Holds if the given `tsconfig.json` object has a `paths` mapping the given `prefix` to `replacement`. */
  pragma[noinline]
  private predicate hasPathMappingPrefix(JSONObject tsconfig, string prefix, string replacement) {
    hasPathMapping(tsconfig, prefix + "*", replacement + "*")
    or
    hasPathMapping(tsconfig, prefix, replacement) and
    not prefix.matches("%*%")
  }

  class TSConfigPathMapping extends ImportResolution::ScopedPathMapping {
    JSONObject tsconfig;

    TSConfigPathMapping() {
      hasPathMappingPrefix(tsconfig, _, _) and
      this = tsconfig.getFile().getParentContainer()
    }

    override predicate replaceByPrefix(string oldPrefix, string newPrefix, Folder root) {
      hasPathMappingPrefix(tsconfig, oldPrefix, newPrefix) and
      root = getBaseUrlFolder(tsconfig)
    }
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

  private string getMappedValue() {
    ImportResolution::replaceByRelativePath(this, _, result)
    or
    not ImportResolution::replaceByRelativePath(this, _, _) and
    result = getValue()
  }

  /** Gets the root folder of priority `priority` associated with this path expression. */
  Folder getSearchRoot(int priority) {
    // We default to the enclosing module's search root, though this may be overridden.
    getEnclosingModule().searchRoot(this, result, priority)
    or
    result = getAdditionalSearchRoot(priority)
    or
    ImportResolution::replaceByRelativePath(this, result, _) and
    priority = -2
    or
    ImportResolution::hasExtraSearchRoot(this, result) and
    priority = -1
  }

  /**
   * INTERNAL. Use `getSearchRoot` instead.
   *
   * Can be overridden by subclasses of `PathExpr` to provide additional search roots
   * without overriding `getSearchRoot`.
   */
  Folder getAdditionalSearchRoot(int priority) { none() }

  /** Gets the `i`th component of this path. */
  string getComponent(int i) { result = getMappedValue().(PathString).getComponent(i) }

  /** Gets the number of components of this path. */
  int getNumComponent() { result = getMappedValue().(PathString).getNumComponent() }

  /** Gets the base name of the folder or file this path refers to. */
  string getBaseName() { result = getMappedValue().(PathString).getBaseName() }

  /** Gets the stem, that is, base name without extension, of the folder or file this path refers to. */
  string getStem() { result = getMappedValue().(PathString).getStem() }

  /**
   * Gets the extension of the folder or file this path refers to, that is, the suffix of the base name
   * starting at the last dot character, if there is one.
   *
   * Has no result if the base name does not contain a dot.
   */
  string getExtension() { result = getMappedValue().(PathString).getExtension() }

  /**
   * Gets the file or folder that the first `n` components of this path refer to
   * when resolved relative to the root folder of the given `priority`.
   */
  pragma[nomagic]
  Container resolveUpTo(int n, int priority) {
    result = getMappedValue().(PathString).resolveUpTo(n, getSearchRoot(priority)).getContainer()
  }

  /**
   * Gets the file or folder that this path refers to when resolved relative to
   * the root folder of the given `priority`.
   */
  Container resolve(int priority) { result = resolveUpTo(getNumComponent(), priority) }

  /**
   * Gets the file or folder that the first `n` components of this path refer to.
   */
  Container resolveUpTo(int n) { result = resolveUpTo(n, min(int p | exists(resolveUpTo(n, p)))) }

  /** Gets the file or folder that this path refers to. */
  Container resolve() { result = resolveUpTo(getNumComponent()) }

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

/** Gets the value of the given SSA definition if it refers to a PathExpr. */
pragma[noinline]
string getValueOfSsaDefinition(SsaExplicitDefinition def) {
  result = def.getDef().getSource().(PathExpr).getValue()
}

/** Gets the value of the given variable use, if its SSA definition refers to a PathExpr. */
pragma[noinline]
string getValueOfSsaDefinitionUse(VarUse e) {
  exists(SsaExplicitDefinition def |
    result = getValueOfSsaDefinition(def) and
    e = def.getVariable().getAUse()
  )
}

/** A variable that is an alias for a PathExpr, itself seen as a PathExpr. */
private class AliasedPathExpr extends PathExpr, VarUse {
  AliasedPathExpr() { exists(getValueOfSsaDefinitionUse(this)) }

  override string getValue() { result = getValueOfSsaDefinitionUse(this) }
}

/**
 * An expression that appears in a syntactic position where it may represent a path.
 *
 * Examples include arguments to the CommonJS `require` function or AMD dependency arguments.
 */
abstract class PathExprCandidate extends Expr {
  /**
   * Gets an expression that is nested inside this expression.
   *
   * Equivalent to `getAChildExpr*()`, but useful to enforce a better join order (in spite of
   * what the optimizer thinks, there are generally far fewer `PathExprCandidate`s than
   * `ConstantString`s).
   */
  pragma[nomagic]
  Expr getAPart() { result = this or result = getAPart().getAChildExpr() }
}

/**
 * Provides classes for customizing import resolution.
 */
module ImportResolution {
  /**
   * A folder in which paths should be resolved differently.
   *
   * The predicates in this class can be overridden by subclasses in order to control how paths
   * should be resolved within this folder.
   *
   * `PathMapping` may be subclassed instead if the mapping should apply everywhere, or if more control
   * is needed by overriding `PathMapping.replaceByRelativePath`.
   */
  abstract class ScopedPathMapping extends Folder {
    /**
     * Whenever an import path matches `regexp`, its path will be replaced by `replacement`
     * and resolved relative to `this` (the scope of the path mapping).
     *
     * The `replacement` string may use `$1`, `$2` and so forth to refer to capture groups from the regexp.
     *
     * For example, if `regexp` is `@/(.*)` and `replacement` is `src/$1`,
     * an import of `@/foo/bar` will be resolved as `src/foo/bar` relative to this folder.
     *
     * More general transformations can be implemented by overriding `replaceByRelativePath` instead.
     */
    predicate replaceByRegExp(string regexp, string replacement) { none() }

    /**
     * Similar to 2-argument version of `replaceByRegExp` but with `root` denoting
     * the folder to resolve the new path from.
     *
     * This can be used if the redirection target is outside the scope of the path mapping itself.
     */
    predicate replaceByRegExp(string regexp, string replacement, Folder root) { none() }

    /**
     * Whenever an import path starts with `oldPrefix`, that prefix is replaced by `newPrefix` and
     * the resulting path is resolved relative to `this` (the scope of the path mapping).
     *
     * In order to match, the prefix must be followed by a path delimeter (`/` or `\`), or match
     * the whole string. For example, the prefix `foo` does not match `foobar/baz` but matches
     * `foo`, `foo/`, and `foo/bar/baz`.
     */
    predicate replaceByPrefix(string oldPrefix, string newPrefix) { none() }

    /**
     * Whenever an import path starts with `oldPrefix`, that prefix is replaced by `newPrefix` and
     * the resulting path is resolved relative to `root`.
     *
     * In order to match, the prefix must be followed by a path delimeter (`/` or `\`), or match
     * the whole string. For example, the prefix `foo` does not match `foobar/baz` but matches
     * `foo`, `foo/`, and `foo/bar/baz`.
     */
    predicate replaceByPrefix(string oldPrefix, string newPrefix, Folder root) { none() }

    /**
     * Holds if any non-relative import path in scope of this path mapping should be attempted to be resolved
     * relative to the given `root` folder.
     */
    predicate isAdditionalRootFolder(Folder root) { none() }

    /**
     * Holds if any non-relative import path in scope of this path mapping should be attempted to be resolved
     * relative to the given `root` folder.
     *
     * This is similar to `isAdditionalRootFolder`, except the `root` is given as a string, interpreted
     * relative to `this`.
     */
    predicate isAdditionalRoot(string root) { none() }
  }

  private predicate isAdditionalRootFolder(ScopedPathMapping mapping, Folder root) {
    mapping.isAdditionalRootFolder(root)
    or
    exists(string rootString |
      mapping.isAdditionalRoot(rootString) and
      root.getRelativePath() =
        (mapping.getRelativePath() + "/" + rootString.replaceAll("\\", "/"))
            .regexpReplaceAll("/\\.?(?=$|/)", "") // remove extra slashes and `/.` segments
    )
  }

  /**
   * The predicates in this class can be overridden by subclasses in order to control how paths
   * should be resolved within this folder.
   *
   * This is a special case of `ScopedPathMapping` where the scope is the source root folder.
   */
  class PathMapping extends ScopedPathMapping, Folder {
    PathMapping() { getRelativePath() = "" }

    /**
     * Replaces the resolution target of `expr` with `root/path`, that is, `path` resolved
     * relative to the given `root` folder.
     */
    predicate replaceByRelativePath(PathExpr expr, Folder root, string path) { none() }
  }

  /** Gets a path mapping effective in `folder`. */
  pragma[noinline]
  private ScopedPathMapping getAPathMappingInScopeAtFolder(Folder folder) {
    result = folder
    or
    result = getAPathMappingInScopeAtFolder(folder.getParentContainer())
  }

  /** Gets a path mapping effective at the given path expression (it may or not actually match). */
  pragma[noinline]
  private ScopedPathMapping getAPathMappingInScopeOfPathExpr(PathExpr expr) {
    result = getAPathMappingInScopeAtFolder(expr.getFile().getParentContainer())
  }

  /**
   * Holds if `value` can be split into the given prefix and suffix without splitting up
   * a path component. See `ScopedPathMapping.replaceByPrefix`.
   */
  bindingset[value, prefix]
  private predicate matchPrefix(string value, string prefix, string suffix) {
    value = prefix + suffix and
    suffix.regexpMatch("(?s)^$|[/\\\\].*") // prefix must be followed by delimeter or the end of the string
  }

  /** Gets a path mapping that matches `expr`. */
  pragma[noinline]
  private ScopedPathMapping getAMatchingPathMapping(PathExpr expr) {
    result = getAPathMappingInScopeOfPathExpr(expr) and
    (
      exists(string regexp |
        result.replaceByRegExp(regexp, _) or result.replaceByRegExp(regexp, _, _)
      |
        expr.(Expr).getStringValue().regexpMatch(regexp)
      )
      or
      exists(string prefix |
        result.replaceByPrefix(prefix, _) or result.replaceByPrefix(prefix, _, _)
      |
        matchPrefix(expr.(Expr).getStringValue(), prefix, _)
      )
    )
    or
    result.(PathMapping).replaceByRelativePath(expr, _, _)
  }

  /** Gets the most specific path mapping that matches `expr`. */
  language[monotonicAggregates]
  pragma[noinline]
  private ScopedPathMapping getMostSpecificPathMapping(PathExpr expr) {
    result =
      max(ScopedPathMapping mapping |
        mapping = getAMatchingPathMapping(expr)
      |
        mapping order by mapping.getRelativePath().length()
      )
  }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Holds if the root of `expr` should be replaced by `root/path`, taking into account
   * contributions all path mappings.
   */
  predicate replaceByRelativePath(PathExpr expr, Folder root, string path) {
    exists(ScopedPathMapping mapping | mapping = getMostSpecificPathMapping(expr) |
      mapping.(PathMapping).replaceByRelativePath(expr, root, path)
      or
      exists(string regexp, string replacement |
        mapping.replaceByRegExp(regexp, replacement) and root = mapping
        or
        mapping.replaceByRegExp(regexp, replacement, root)
      |
        path = expr.(Expr).getStringValue().regexpReplaceAll(regexp, replacement)
      )
      or
      exists(string prefix, string replacement, string suffix |
        mapping.replaceByPrefix(prefix, replacement) and root = mapping
        or
        mapping.replaceByPrefix(prefix, replacement, root)
      |
        matchPrefix(expr.(Expr).getStringValue(), prefix, suffix) and
        path = replacement + suffix
      )
    )
  }

  /**
   * Holds if an import mapping has provided `root` as an extra search root for `expr`.
   */
  predicate hasExtraSearchRoot(PathExpr expr, Folder root) {
    isAdditionalRootFolder(getAPathMappingInScopeOfPathExpr(expr), root)
  }

  private class MappedPathString extends PathString {
    MappedPathString() { replaceByRelativePath(_, _, this) }

    override Folder getARootFolder() {
      replaceByRelativePath(_, result, this)
      or
      exists(PathExpr expr |
        expr.getValue() = this and
        hasExtraSearchRoot(expr, result)
      )
      or
      // Absolute paths should be resolved from the root
      charAt(0) = "/" and
      not exists(result.getParentContainer())
    }
  }
}
