/**
 * Provides predicates for resolving external action and workflow references
 * through SHA-based mapping files.
 */

private import codeql.actions.ast.internal.Yaml

/**
 * Holds if the external action mapping file maps `ownerRepo` at `ref` to `sha`.
 *
 * The mapping file is expected at `.github/actions/external/mapping.yaml` and has
 * the following structure:
 * ```yaml
 * owner/repo:
 *   ref: sha
 * ```
 *
 * This enables SHA-based directory resolution for external composite actions
 * stored in the `.github/actions/external/{owner}/{repo}/{sha}/` directory structure.
 */
predicate externalActionRefMapping(string ownerRepo, string ref, string sha) {
  exists(YamlMapping mapping, YamlMapping refMap |
    (
      mapping.getLocation().getFile().getRelativePath().matches("%/.github/actions/external/mapping.yaml")
      or
      mapping.getLocation().getFile().getRelativePath() = ".github/actions/external/mapping.yaml"
    ) and
    refMap = mapping.lookup(ownerRepo) and
    sha = refMap.lookup(ref).(YamlScalar).getValue()
  )
}

/**
 * Holds if the external workflow mapping file maps `ownerRepo` at `ref` to `sha`.
 *
 * The mapping file is expected at `.github/workflows/external/mapping.yaml` and has
 * the same structure as the action mapping file.
 */
predicate externalWorkflowRefMapping(string ownerRepo, string ref, string sha) {
  exists(YamlMapping mapping, YamlMapping refMap |
    (
      mapping.getLocation().getFile().getRelativePath().matches("%/.github/workflows/external/mapping.yaml")
      or
      mapping.getLocation().getFile().getRelativePath() = ".github/workflows/external/mapping.yaml"
    ) and
    refMap = mapping.lookup(ownerRepo) and
    sha = refMap.lookup(ref).(YamlScalar).getValue()
  )
}
