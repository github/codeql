private import unified
private import codeql.util.ReportStats
private import codeql.unified.internal.StaticNameBinding
private import codeql.unified.internal.LocalNameBinding
private import codeql.unified.internal.NameBindingPlugin

/** Stats about identifiers that static name binding could resolve. */
module StaticNameResolutionStats implements EntityStatsSig {
  class Candidate extends Identifier {
    Candidate() {
      this = getIdentifierFromRef(_) and
      not this instanceof NameDeclaration
      // TODO: exclude names we know are not static references, e.g. unqualified instance-field access,
      // currently blocked on getting static name binding to report this information.
    }

    NameBindingNode getTarget() {
      (
        exists(NameDeclaration decl |
          result.isIdentifier(decl) and
          trackNameDeclaration(decl).isIdentifier(this)
        )
        or
        result.isModuleScopeNode(_) and
        result.(NamespaceNode).ref().isIdentifier(this)
      ) and
      // Do not consider a type extension to be a valid target
      // TODO: Fix in the AST mapping: type extensions should reference their type, not declare it
      not exists(ClassLikeDeclaration cls |
        cls.hasModifier("extension") and
        result.isIdentifier(cls.getName())
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
