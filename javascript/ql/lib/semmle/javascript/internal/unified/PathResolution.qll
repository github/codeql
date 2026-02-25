overlay[local]
module;

private import minimal.minimal
private import JSUnified
private import DataFlowBuilder
private import Contents
private import minimal.JSPaths
private import minimal.PathMapping
private import minimal.PathConcatenation
private import semmle.javascript.internal.unified.Constant

private predicate moduleSystemAliases(string name) { name = ["require"] }

private module ModuleSystemAliases = ModelsAsData::EvaluatePreCallGraph<moduleSystemAliases/1>;

class RequireCall extends CallExpr {
  RequireCall() { ModuleSystemAliases::getAnAliasSource("require").isValueOf(this.getCallee()) }

  string getImportedString() { result = PathStrings::getValueOfExpr(this.getArgument(0)) }
}

predicate pathResolutionStep(DataFlow2::Node path, DataFlow2::Node importedModule) {
  exists(RequireCall call |
    path.isValueOf(call.getArgument(0)) and
    importedModule.isValueOf(call)
  )
  or
  exists(AstNode tagged |
    path.isValueOf(tagged) and
    importedModule.isSyntheticNode(tagged, "imported-module")
  )
}

private module PathStringsInput implements ValuePropagationInputSig {
  class Value extends string {
    bindingset[this]
    Value() { this.length() < 200 }
  }

  predicate shouldComputeValue(DataFlow2::Node node) { pathResolutionStep(node, _) }

  predicate allowMayFlow() { none() }

  private import PathStrings

  language[monotonicAggregates]
  private string getValueFromConcat(PathConcatenation c) {
    result =
      concat(Expr e, int i | e = c.getOperand(i) | getValueOfExpr(e), c.getSeparator() order by i)
  }

  private class PathStringFolding extends ValuePropagationRule {
    bindingset[node]
    override DataFlow2::Node getADependency(DataFlow2::Node node) {
      exists(AddExpr binary |
        node.isValueOf(binary) and
        result.isValueOf(binary.getAnOperand())
      )
      or
      exists(AssignAddExpr add |
        node.isIncomingValue(add.getTarget()) and
        result.isValueOf([add.getTarget(), add.getRhs()])
      )
    }

    bindingset[node]
    override Value computeValue(DataFlow2::Node node) {
      exists(PathConcatenation c |
        node.isValueOf(c) and
        result = getValueFromConcat(c)
      )
      or
      // Compound assignments must be handled here since the AST-based abstraction in 'PathConcatenation' cannot handle them
      exists(AssignAddExpr add |
        node.isIncomingValue(add.getTarget()) and
        result = getValueOfExpr(add.getTarget()) + getValueOfExpr(add.getRhs())
      )
      or
      exists(StringLiteral expr |
        node.isValueOf(expr) and
        result = expr.getStringValue()
      )
    }
  }
}

module PathStrings = MakeValuePropagation<PathStringsInput>;

private class RelevantNode extends DataFlow2::Node {
  string getValue() { result = PathStrings::getValue(this) }

  /** Gets a path mapping affecting this path. */
  overlay[global]
  pragma[nomagic]
  PathMapping getAPathMapping() { result.getAnAffectedFile() = this.getFile() }

  /** Gets the NPM package name from the beginning of this path. */
  overlay[global]
  pragma[nomagic]
  string getPackagePrefix() { result = this.getValue().(FilePath).getPackagePrefix() }

  File getFile() { result = this.getLocation().getFile() }
}

/**
 * Holds if `expr` matches a path mapping, and should thus be resolved as `newPath` relative to `base`.
 */
overlay[global]
pragma[nomagic]
private predicate resolveViaPathMapping(RelevantNode expr, Container base, string newPath) {
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

overlay[global]
pragma[noopt]
private predicate relativePathExpr(RelevantNode expr, Container base, FilePath path) {
  expr instanceof RelevantNode and
  path = expr.getValue() and
  path.isDotRelativePath() and
  exists(File file |
    file = expr.getFile() and
    base = file.getParentContainer()
  )
}

overlay[global]
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
overlay[global]
pragma[nomagic]
private predicate shouldResolve(RelevantNode expr, Container base, FilePath path) {
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

overlay[global]
private module ResolverConfig implements Folder::ResolveSig {
  predicate shouldResolve(Container base, string path) { shouldResolve(_, base, path) }

  predicate getAnAdditionalChild = JSPaths::getAnAdditionalChild/2;
}

private module Resolver = Folder::Resolve<ResolverConfig>;

overlay[global]
private Container resolvePathExpr1(RelevantNode expr) {
  exists(Container base, string path |
    shouldResolve(expr, base, path) and
    result = Resolver::resolve(base, path)
  )
}

/**
 * Gets the file to import when an imported path resolves to the given `folder`.
 */
overlay[global]
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

overlay[global]
File resolveExpr(RelevantNode expr) {
  result = resolvePathExpr1(expr)
  or
  result = getFileFromFolderImport(resolvePathExpr1(expr))
}

overlay[global]
private predicate importStepAux(
  DataFlow2::Node pathNode, DataFlow2::Node node1, DataFlow2::Node node2
) {
  exists(TopLevel target |
    pathResolutionStep(pathNode, node2) and
    resolveExpr(pathNode) = target.getFile() and
    node1.isNamespaceObject(NamespaceObject::moduleObject(target))
  )
}

overlay[global]
predicate importStep(DataFlow2::Node node1, DataFlowBuilder::Step step, DataFlow2::Node node2) {
  importStepAux(_, node1, node2) and
  step.read(Contents::property("exports"))
}
