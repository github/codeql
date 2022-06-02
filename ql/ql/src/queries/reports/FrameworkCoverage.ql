/**
 * An experimental and incomplete query for measuring framework coverage
 * for models implemented in CodeQL.
 *
 * Currently only supports JavaScript models, and simply lists the package names
 * alongside the named features accessed on such a package.
 */

import ql
import codeql_ql.ast.internal.AstNodes
import codeql_ql.dataflow.DataFlow as DataFlow

predicate isExcludedFile(File file) {
  file.getAbsolutePath().matches(["%ql/experimental/%", "%ql/test/%"])
}

class PackageImportCall extends PredicateCall {
  PackageImportCall() {
    this.getQualifier().getName() = ["API", "DataFlow"] and
    this.getPredicateName() = ["moduleImport", "moduleMember"] and
    not isExcludedFile(getLocation().getFile())
  }

  /** Gets the name of a package referenced by this call */
  string getAPackageName() { result = DataFlow::superNode(getArgument(0)).getAStringValueNoCall() }
}

/** Gets a reference to `package` or any transitive member thereof. */
DataFlow::SuperNode getADerivedRef(string package, DataFlow::Tracker t) {
  t.start() and
  result.asAstNode().(PackageImportCall).getAPackageName() = package
  or
  exists(DataFlow::Tracker t2 | result = getADerivedRef(package, t2).track(t2, t))
  or
  result.asAstNode() = getADerivedCall(package, t)
}

/** Gets a call which models some aspect of `package`. */
MemberCall getADerivedCall(string package, DataFlow::Tracker t) {
  result = getADerivedRef(package, t).getALocalMemberCall() and
  not result.(Expr).getType().getName() = ["int", "string"]
}

/**
 * Gets an expression whose string-value is the name of a member accessed from `package`,
 * where the underlying package node was tracked here using `t`.
 */
Expr getAFeatureUse(string package, DataFlow::Tracker t) {
  exists(MemberCall call | call = getADerivedCall(package, t) |
    call.getMemberName() =
      [
        "getMember", "getAPropertyRead", "getAPropertyWrite", "getAPropertyReference",
        "getAPropertySource", "getAMethodCall", "getAMemberCall"
      ] and
    result = call.getArgument(0)
    or
    call.getMemberName() = "getOptionArgument" and
    result = call.getArgument(1)
  )
  or
  t.start() and
  exists(PackageImportCall call |
    call.getAPackageName() = package and
    call.getPredicateName() = "moduleMember" and
    result = call.getArgument(1)
  )
}

/**
 * Gets the name of a feature accessed as `use`.
 */
string getAFeatureName(string package, Expr use) {
  exists(DataFlow::Tracker t |
    use = getAFeatureUse(package, t) and
    result = DataFlow::superNode(use).getAStringValueForContext(t)
  )
}

query predicate packageFeatures(string package, string features) {
  // TODO: 'express' still missing features from request objects - likely subclassing-related
  package = any(PackageImportCall call).getAPackageName() and
  features = concat(getAFeatureName(package, _), ", ")
}

/** Holds if `cls` extends an abstract class from another file. */
predicate isCrossFileContribution(Class cls) {
  exists(Class sup |
    cls.getASuperType().getResolvedType().getDeclaration() = sup and
    sup.isAbstract() and
    sup.getLocation().getFile() != cls.getLocation().getFile()
  )
}

query predicate packageConcepts(string package, Class concept) {
  package = any(PackageImportCall call).getAPackageName() and
  getADerivedRef(package, DataFlow::Tracker::endNoCall()).getANode() =
    DataFlow::thisNode(concept.getCharPred()) and
  isCrossFileContribution(concept)
}

query predicate importWithoutPackageName(PackageImportCall call, string path) {
  not exists(call.getAPackageName()) and
  path = call.getLocation().getFile().getRelativePath()
}
