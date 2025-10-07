private import javascript
private import semmle.javascript.internal.paths.PackageJsonEx
private import semmle.javascript.internal.paths.JSPaths
private import semmle.javascript.internal.paths.PathMapping
private import semmle.javascript.internal.paths.PathConcatenation
private import semmle.javascript.dataflow.internal.DataFlowNode

/**
 * Gets the file to import when an imported path resolves to the given `folder`.
 */
File getFileFromFolderImport(Folder folder) {
  result = folder.getJavaScriptFileOrTypings("index")
  or
  // Note that unlike "exports" paths, "main" and "module" also take effect when the package
  // is imported via a relative path, e.g. `require("..")` targeting a folder with a package.json file.
  exists(PackageJsonEx pkg |
    pkg.getFolder() = folder and
    result = pkg.getMainFileOrBestGuess()
  )
}

private Variable dirnameVar() { result.getName() = "__dirname" }

private Variable filenameVar() { result.getName() = "__filename" }

private signature predicate exprSig(Expr e);

module ResolveExpr<exprSig/1 shouldResolveExpr> {
  /** Holds if we need the constant string-value of `node`. */
  private predicate needsConstantFolding(EarlyStageNode node) {
    exists(Expr e |
      shouldResolveExpr(e) and
      node = TValueNode(e)
    )
    or
    exists(EarlyStageNode needsFolding | needsConstantFolding(needsFolding) |
      DataFlow::Impl::earlyStageImmediateFlowStep(node, needsFolding)
      or
      exists(PathConcatenation joiner |
        needsFolding = TValueNode(joiner) and
        node = TValueNode(joiner.getOperand(_))
      )
    )
  }

  /** Gets the constant-value of `node` */
  language[monotonicAggregates]
  private string getValue(EarlyStageNode node) {
    needsConstantFolding(node) and
    (
      exists(Expr e | node = TValueNode(e) |
        result = e.getStringValue()
        or
        e = dirnameVar().getAnAccess() and
        result = "./" // Ensure the path gets interpreted relative to the current directory
        or
        e = filenameVar().getAnAccess() and
        result = "./" + e.getFile().getBaseName()
      )
      or
      exists(EarlyStageNode pred |
        DataFlow::Impl::earlyStageImmediateFlowStep(pred, node) and
        result = getValue(pred)
      )
      or
      exists(PathConcatenation join |
        node = TValueNode(join) and
        // Note: 'monotonicAggregates' above lets us use recursion in the last clause of this aggregate
        result =
          strictconcat(int n, EarlyStageNode child, string sep |
            child = TValueNode(join.getOperand(n)) and sep = join.getSeparator()
          |
            getValue(child), sep order by n
          )
      )
    )
  }

  final private class FinalExpr = Expr;

  private class RelevantExpr extends FinalExpr {
    RelevantExpr() { shouldResolveExpr(this) }

    /** Gets the string-value of this path. */
    string getValue() { result = getValue(TValueNode(this)) }

    /** Gets a path mapping affecting this path. */
    pragma[nomagic]
    PathMapping getAPathMapping() { result.getAnAffectedFile() = this.getFile() }

    /** Gets the NPM package name from the beginning of this path. */
    pragma[nomagic]
    string getPackagePrefix() { result = this.getValue().(FilePath).getPackagePrefix() }
  }

  /**
   * Holds if `expr` matches a path mapping, and should thus be resolved as `newPath` relative to `base`.
   */
  pragma[nomagic]
  private predicate resolveViaPathMapping(RelevantExpr expr, Container base, string newPath) {
    // Handle path mappings such as `{ "paths": { "@/*": "./src/*" }}` in a tsconfig.json file
    exists(PathMapping mapping, string value |
      mapping = expr.getAPathMapping() and
      value = expr.getValue()
    |
      mapping.hasExactPathMapping(value, base, newPath)
      or
      exists(string pattern, string suffix, string mappedPath |
        mapping.hasPrefixPathMapping(pattern, base, mappedPath) and
        value = pattern + suffix and
        newPath = mappedPath + suffix
      )
    )
    or
    // Handle imports referring to a package by name, where we have a package.json
    // file for that package in the codebase. This is treated separately from PathMapping for performance
    // reasons, as there can be a large number of packages which affect all files in the project.
    //
    // This part only handles the "exports" property of package.json. "main" and "modules" are
    // handled further down because their semantics are easier to handle there.
    exists(PackageJsonEx pkg, string packageName, string remainder |
      packageName = expr.getPackagePrefix() and
      pkg.getDeclaredPackageName() = packageName and
      remainder = expr.getValue().suffix(packageName.length()).regexpReplaceAll("^[/\\\\]", "")
    |
      // "exports": { ".": "./foo.js" }
      // "exports": { "./foo.js": "./foo/impl.js" }
      pkg.hasExactPathMappingTo(remainder, base) and
      newPath = ""
      or
      // "exports": { "./*": "./foo/*" }
      exists(string prefix |
        pkg.hasPrefixPathMappingTo(prefix, base) and
        remainder = prefix + newPath
      )
    )
  }

  pragma[noopt]
  private predicate relativePathExpr(RelevantExpr expr, Container base, FilePath path) {
    expr instanceof RelevantExpr and
    path = expr.getValue() and
    path.isDotRelativePath() and
    exists(File file |
      file = expr.getFile() and
      base = file.getParentContainer()
    )
  }

  pragma[nomagic]
  private Container getJSDocProvidedModule(string moduleName) {
    exists(JSDocTag tag |
      tag.getTitle() = "providesModule" and
      tag.getDescription().trim() = moduleName and
      tag.getFile() = result
    )
  }

  /**
   * Holds if `expr` should be resolved as `path` relative to `base`.
   */
  pragma[nomagic]
  private predicate shouldResolve(RelevantExpr expr, Container base, FilePath path) {
    // Relative paths are resolved from their enclosing folder
    relativePathExpr(expr, base, path)
    or
    resolveViaPathMapping(expr, base, path)
    or
    // Resolve from baseUrl of relevant tsconfig.json file
    path = expr.getValue() and
    not path.isDotRelativePath() and
    expr.getAPathMapping().hasBaseUrl(base)
    or
    // If the path starts with the name of a package, resolve relative to the directory of that package.
    // Note that `getFileFromFolderImport` may subsequently redirect this to the package's "main",
    // so we don't have to deal with that here.
    exists(PackageJson pkg, string packageName |
      packageName = expr.getPackagePrefix() and
      pkg.getDeclaredPackageName() = packageName and
      path = expr.getValue().suffix(packageName.length()) and
      base = pkg.getFolder()
    )
    or
    base = getJSDocProvidedModule(expr.getValue()) and
    path = ""
  }

  private module ResolverConfig implements Folder::ResolveSig {
    predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

    predicate getAnAdditionalChild = JSPaths::getAnAdditionalChild/2;
  }

  private module Resolver = Folder::Resolve<ResolverConfig>;

  private Container resolvePathExpr1(RelevantExpr expr) {
    exists(Container base, string path |
      shouldResolve(expr, base, path) and
      result = Resolver::resolve(base, path)
    )
  }

  File resolveExpr(RelevantExpr expr) {
    result = resolvePathExpr1(expr)
    or
    result = getFileFromFolderImport(resolvePathExpr1(expr))
  }

  module Debug {
    class PathExprToDebug extends RelevantExpr {
      PathExprToDebug() { this.getValue() = "vs/nls" }
    }

    query PathExprToDebug pathExprs() { any() }

    query string getPackagePrefixFromPathExpr_(PathExprToDebug expr) {
      result = expr.getPackagePrefix()
    }

    query predicate resolveViaPathMapping_(PathExprToDebug expr, Container base, string newPath) {
      resolveViaPathMapping(expr, base, newPath)
    }

    query predicate shouldResolve_(PathExprToDebug expr, Container base, string newPath) {
      shouldResolve(expr, base, newPath)
    }

    query Container resolvePathExpr1_(PathExprToDebug expr) { result = resolvePathExpr1(expr) }

    query File resolveExpr_(PathExprToDebug expr) { result = resolveExpr(expr) }

    // Some predicates that are usually small enough that they don't need restriction
    query File getPackageMainFile(PackageJsonEx pkg) { result = pkg.getMainFile() }

    query predicate guessPackageJsonMain1_ = guessPackageJsonMain1/1;

    query predicate guessPackageJsonMain2_ = guessPackageJsonMain2/1;

    query predicate getFileFromFolderImport_ = getFileFromFolderImport/1;
  }
}

private predicate isImportPathExpr(Expr e) {
  e = any(Import imprt).getImportedPathExpr()
  or
  e = any(ReExportDeclaration decl).getImportedPath()
}

/** Resolves paths in imports and re-exports. */
module ImportPathResolver = ResolveExpr<isImportPathExpr/1>;
