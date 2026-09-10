private import unified
private import codeql.util.ReportStats
private import codeql.unified.internal.StaticNameBinding
private import codeql.unified.internal.LocalNameBinding
private import codeql.unified.internal.NameBindingPlugin

/** Stats about identifiers that static name binding could resolve. */
module StaticNameResolutionStats implements EntityStatsSig {
  /**
   * Holds if `name` has been positively identified as referring to a value, so static name binding
   * is not expected to resolve its members.
   */
  private predicate resolvesToValue(Identifier name) {
    exists(AstNode decl |
      decl = getStaticBindingTarget(name).getDeclaration() and
      not decl instanceof ClassLikeDeclaration and
      not decl instanceof TypeAliasDeclaration and
      not decl instanceof TypeParameter and
      not decl instanceof AssociatedTypeDeclaration
    )
  }

  /**
   * Holds if name-binding for `expr` depends on type inference, and is thus not subject to static name binding.
   *
   * Usually this holds for qualified instance member accesses (`foo().x`) and leading-dot expressions (`.x`).
   */
  private predicate memberAccessDependsOnTypeInference(MemberAccessExpr expr) {
    exists(Expr base | base = expr.getBase() |
      // Base expression resolves to a value, e.g. a field, variable, or function (for languages where functions are values).
      resolvesToValue(getIdentifierFromRef(base))
      or
      // Base expression is of a kind that is not subject to static name resolution, e.g. `foo().x`
      not exists(getIdentifierFromRef(base))
      or
      // Base expression is a confirmed to depend on type inference
      memberAccessDependsOnTypeInference(base)
    )
  }

  class Candidate extends Identifier {
    Candidate() {
      exists(AstNode ref |
        this = getIdentifierFromRef(ref) and
        not memberAccessDependsOnTypeInference(ref)
      ) and
      not this instanceof NameDeclaration
    }

    NameBindingNode getTarget() {
      (
        result.asIdentifier() = getStaticBindingTarget(this)
        or
        result.isModuleScopeNode(_) and
        result.(NamespaceNode).ref().isIdentifier(this)
      )
    }

    predicate isOk() { exists(this.getTarget()) }
  }

  string getOkText() { result = "statically resolvable names" }

  string getNotOkText() { result = "statically unresolvable names" }
}

module StaticNameResolutionStatsReport = EntityReportStats<StaticNameResolutionStats>;

/** Stats about which files are covered by a module manifest. */
module FilesCoveredByModuleManifestStats implements EntityStatsSig {
  class Candidate extends File {
    Candidate() { this.getExtension() = "swift" }

    ModuleScopeRepr getAModule() { result.getAnIncludedFile() = this }

    predicate isOk() { exists(this.getAModule()) }
  }

  string getOkText() { result = "files covered by a module manifest" }

  string getNotOkText() { result = "files not covered by any module manifest" }
}

module FilesCoveredByModuleManifestStatsReport =
  EntityReportStats<FilesCoveredByModuleManifestStats>;
