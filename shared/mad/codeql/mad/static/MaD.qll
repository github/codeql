overlay[local?]
module;

signature module ExtensionsSig {
  /**
   * Holds if a source model exists for the given parameters.
   */
  predicate sourceModel(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance, QlBuiltins::ExtensionId madId
  );

  /**
   * Holds if a sink model exists for the given parameters.
   */
  predicate sinkModel(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string input, string kind, string provenance, QlBuiltins::ExtensionId madId
  );

  /**
   * Holds if a barrier model exists for the given parameters.
   */
  predicate barrierModel(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string output, string kind, string provenance, QlBuiltins::ExtensionId madId
  );

  /**
   * Holds if a barrier guard model exists for the given parameters.
   */
  predicate barrierGuardModel(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string input, string acceptingvalue, string kind, string provenance,
    QlBuiltins::ExtensionId madId
  );

  /**
   * Holds if a summary model exists for the given parameters.
   */
  predicate summaryModel(
    string namespace, string type, boolean subtypes, string name, string signature, string ext,
    string input, string output, string kind, string provenance, QlBuiltins::ExtensionId madId
  );

  /**
   * Holds if a neutral model exists for the given parameters.
   */
  predicate neutralModel(
    string namespace, string type, string name, string signature, string kind, string provenance
  );
}

module ModelsAsData<ExtensionsSig Extensions> {
  /**
   * Holds if the given extension tuple `madId` should pretty-print as `model`.
   *
   * Barrier models are included for completeness even though they will not show up in a path.
   *
   * This predicate should only be used in tests.
   */
  predicate interpretModelForTest(QlBuiltins::ExtensionId madId, string model) {
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      string output, string kind, string provenance
    |
      Extensions::sourceModel(namespace, type, subtypes, name, signature, ext, output, kind,
        provenance, madId)
    |
      model =
        "Source: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature +
          "; " + ext + "; " + output + "; " + kind + "; " + provenance
    )
    or
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      string input, string kind, string provenance
    |
      Extensions::sinkModel(namespace, type, subtypes, name, signature, ext, input, kind,
        provenance, madId)
    |
      model =
        "Sink: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature + "; "
          + ext + "; " + input + "; " + kind + "; " + provenance
    )
    or
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      string output, string kind, string provenance
    |
      Extensions::barrierModel(namespace, type, subtypes, name, signature, ext, output, kind,
        provenance, madId)
    |
      model =
        "Barrier: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature +
          "; " + ext + "; " + output + "; " + kind + "; " + provenance
    )
    or
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      string input, string acceptingvalue, string kind, string provenance
    |
      Extensions::barrierGuardModel(namespace, type, subtypes, name, signature, ext, input,
        acceptingvalue, kind, provenance, madId)
    |
      model =
        "Barrier Guard: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " +
          signature + "; " + ext + "; " + input + "; " + acceptingvalue + "; " + kind + "; " +
          provenance
    )
    or
    exists(
      string namespace, string type, boolean subtypes, string name, string signature, string ext,
      string input, string output, string kind, string provenance
    |
      Extensions::summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind,
        provenance, madId)
    |
      model =
        "Summary: " + namespace + "; " + type + "; " + subtypes + "; " + name + "; " + signature +
          "; " + ext + "; " + input + "; " + output + "; " + kind + "; " + provenance
    )
  }

  private predicate relevantNamespace(string namespace) {
    Extensions::sourceModel(namespace, _, _, _, _, _, _, _, _, _) or
    Extensions::sinkModel(namespace, _, _, _, _, _, _, _, _, _) or
    Extensions::summaryModel(namespace, _, _, _, _, _, _, _, _, _, _)
  }

  private predicate namespaceLink(string shortns, string longns) {
    relevantNamespace(shortns) and
    relevantNamespace(longns) and
    longns.prefix(longns.indexOf(".")) = shortns
  }

  private predicate canonicalNamespace(string namespace) {
    relevantNamespace(namespace) and not namespaceLink(_, namespace)
  }

  private predicate canonicalNamespaceLink(string namespace, string subns) {
    canonicalNamespace(namespace) and
    (subns = namespace or namespaceLink(namespace, subns))
  }

  /**
   * Holds if MaD framework coverage of `namespace` is `n` api endpoints of the
   * kind `(kind, part)`, and `namespaces` is the number of subnamespaces of
   * `namespace` which have MaD framework coverage (including `namespace`
   * itself).
   */
  predicate modelCoverage(string namespace, int namespaces, string kind, string part, int n) {
    namespaces = strictcount(string subns | canonicalNamespaceLink(namespace, subns)) and
    (
      part = "source" and
      n =
        strictcount(string subns, string type, boolean subtypes, string name, string signature,
          string ext, string output, string provenance |
          canonicalNamespaceLink(namespace, subns) and
          Extensions::sourceModel(subns, type, subtypes, name, signature, ext, output, kind,
            provenance, _)
        )
      or
      part = "sink" and
      n =
        strictcount(string subns, string type, boolean subtypes, string name, string signature,
          string ext, string input, string provenance |
          canonicalNamespaceLink(namespace, subns) and
          Extensions::sinkModel(subns, type, subtypes, name, signature, ext, input, kind,
            provenance, _)
        )
      or
      part = "summary" and
      n =
        strictcount(string subns, string type, boolean subtypes, string name, string signature,
          string ext, string input, string output, string provenance |
          canonicalNamespaceLink(namespace, subns) and
          Extensions::summaryModel(subns, type, subtypes, name, signature, ext, input, output, kind,
            provenance, _)
        )
    )
  }
}
