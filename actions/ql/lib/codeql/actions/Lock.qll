/**
 * Provides classes for working with GitHub Actions lockfiles.
 */

private import actions
private import codeql.actions.ast.internal.Yaml

/** A `.github/workflows/actions.lock` file. */
class ActionsLock extends YamlDocument, YamlMapping {
  ActionsLock() { this.getFile().getRelativePath() = ".github/workflows/actions.lock" }

  private predicate pins0(string workflowPath, string pinnedNwo, string ref) {
    exists(YamlSequence workflowPins, YamlScalar pinNode, YamlMapping dependency, string pin |
      this.lookup("workflows").(YamlMapping).lookup(workflowPath) = workflowPins and
      workflowPins.getElement(_) = pinNode and
      pin = pinNode.getValue() and
      pinnedNwo = pin.regexpCapture("^([^/@:]+/[^/@:]+)@([^:]+)$", 1) and
      ref = pin.regexpCapture("^([^/@:]+/[^/@:]+)@([^:]+)$", 2) and
      this.lookup("dependencies").(YamlMapping).lookup(pin) = dependency and
      dependency.lookup("ref").(YamlScalar).getValue() = ref and
      dependency
          .lookup("commit")
          .(YamlScalar)
          .getValue()
          .regexpMatch("^(sha1-[A-Fa-f0-9]{40}|sha256-[A-Fa-f0-9]{64})$")
    )
  }

  /**
   * Holds if this lockfile pins the use at `uses` to `ref` with a full commit digest.
   * Repository pins also cover sub-actions such as `actions/cache/save`.
   */
  predicate pins(UsesStep uses, string ref) {
    exists(string workflowPath, string pinnedNwo, string nwo |
      this.pins0(workflowPath, pinnedNwo, ref) and
      workflowPath = uses.getLocation().getFile().getRelativePath() and
      nwo = uses.getCallee()
    |
      nwo.toLowerCase() = pinnedNwo.toLowerCase()
      or
      nwo.toLowerCase().prefix(pinnedNwo.length() + 1) = pinnedNwo.toLowerCase() + "/"
    )
  }
}
