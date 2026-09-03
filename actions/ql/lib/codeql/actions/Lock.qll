/**
 * Provides classes for working with GitHub Actions lockfiles.
 */

private import codeql.actions.ast.internal.Yaml

/** An `actions.lock` file. */
class ActionsLock extends YamlDocument {
  ActionsLock() { this.getFile().getBaseName() = "actions.lock" }

  /**
   * Holds if the lockfile records `nwo` at `ref` for `workflowPath` with positive owner and
   * repository IDs and a full commit digest. Repository pins also cover sub-actions such as
   * `actions/cache/save`.
   */
  bindingset[nwo]
  predicate pins(string workflowPath, string nwo, string ref) {
    this.getFile().getRelativePath() = ".github/workflows/actions.lock" and
    exists(
      YamlMapping root, YamlSequence workflowPins, YamlScalar pinNode, YamlMapping dependency,
      string pin, string pinnedNwo
    |
      root = this and
      root.lookup("workflows").(YamlMapping).lookup(workflowPath) = workflowPins and
      workflowPins.getElement(_) = pinNode and
      pin = pinNode.getValue() and
      pinnedNwo = pin.regexpCapture("^([^/@:]+/[^/@:]+)@([^:]+)$", 1) and
      ref = pin.regexpCapture("^([^/@:]+/[^/@:]+)@([^:]+)$", 2) and
      (
        nwo.toLowerCase() = pinnedNwo.toLowerCase()
        or
        nwo.toLowerCase().prefix(pinnedNwo.length() + 1) = pinnedNwo.toLowerCase() + "/"
      ) and
      root.lookup("dependencies").(YamlMapping).lookup(pin) = dependency and
      dependency.lookup("ref").(YamlScalar).getValue() = ref and
      dependency.lookup("owner_id").(YamlScalar).getValue().toInt() > 0 and
      dependency.lookup("repo_id").(YamlScalar).getValue().toInt() > 0 and
      dependency
          .lookup("commit")
          .(YamlScalar)
          .getValue()
          .regexpMatch("^(sha1-[A-Fa-f0-9]{40}|sha256-[A-Fa-f0-9]{64})$")
    )
  }
}
