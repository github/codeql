/**
 * Provides classes for working with GitHub Actions lockfiles.
 */

private import actions
private import codeql.actions.ast.internal.Yaml

bindingset[path]
private string normalizeLocalCompositePath(string path) {
  result = path.regexpReplaceAll("(^|/)\\./", "$1").regexpReplaceAll("/+$", "")
}

private string compositeActionPath(CompositeAction action) {
  result =
    action.getLocation().getFile().getRelativePath().regexpReplaceAll("/action\\.(yml|yaml)$", "")
}

private predicate callsLocalComposite(UsesStep caller, CompositeAction action) {
  exists(string path |
    caller.getCallee() = "$/" + path and
    not exists(caller.getVersion()) and
    normalizeLocalCompositePath(path) = compositeActionPath(action)
  )
}

private predicate hasUncoveredDotCaller(CompositeAction action) {
  exists(UsesStep caller, string path |
    caller.getCallee().indexOf("./") = 0 and
    path = caller.getCallee().suffix(2) and
    (
      normalizeLocalCompositePath(path) = compositeActionPath(action) or
      normalizeLocalCompositePath(path).endsWith("/" + compositeActionPath(action))
    )
  )
}

private predicate isRepositoryRootAction(CompositeAction action) {
  action.getLocation().getFile().getRelativePath() = ["action.yml", "action.yaml"]
}

private predicate compositeCaller(CompositeAction action, CompositeAction caller) {
  callsLocalComposite(any(UsesStep step | step.getEnclosingCompositeAction() = caller), action)
}

/** A `.github/workflows/actions.lock` file. */
class ActionsLock extends YamlDocument, YamlMapping {
  ActionsLock() { this.getFile().getRelativePath() = ".github/workflows/actions.lock" }

  pragma[nomagic]
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

  private predicate pinsInWorkflow(UsesStep uses, string ref, string workflowPath) {
    exists(string pinnedNwo, string nwo |
      this.pins0(workflowPath, pinnedNwo, ref) and
      nwo = uses.getCallee()
    |
      nwo.toLowerCase() = pinnedNwo.toLowerCase()
      or
      nwo.toLowerCase().prefix(pinnedNwo.length() + 1) = pinnedNwo.toLowerCase() + "/"
    )
  }

  /**
   * Holds if this lockfile pins the use at `uses` to `ref` with a full commit digest.
   * Repository pins also cover sub-actions such as `actions/cache/save`. For a use in a
   * local composite action, every known calling workflow must pin the dependency. Only
   * repository-rooted `$/` callers are covered; workspace-relative callers and external
   * consumers of the repository root action are not represented by the lockfile.
   */
  predicate pins(UsesStep uses, string ref) {
    this.pinsInWorkflow(uses, ref,
      uses.getEnclosingWorkflow().getLocation().getFile().getRelativePath())
    or
    exists(CompositeAction action |
      action = uses.getEnclosingCompositeAction() and
      exists(CompositeAction ancestor, UsesStep caller, Workflow workflow |
        compositeCaller*(action, ancestor) and
        callsLocalComposite(caller, ancestor) and
        workflow = caller.getEnclosingWorkflow() and
        this.pinsInWorkflow(uses, ref, workflow.getLocation().getFile().getRelativePath())
      ) and
      not exists(CompositeAction ancestor |
        compositeCaller*(action, ancestor) and
        not exists(CompositeAction root, UsesStep caller, Workflow workflow |
          compositeCaller*(ancestor, root) and
          callsLocalComposite(caller, root) and
          workflow = caller.getEnclosingWorkflow()
        )
      ) and
      not exists(CompositeAction ancestor |
        compositeCaller*(action, ancestor) and
        (isRepositoryRootAction(ancestor) or hasUncoveredDotCaller(ancestor))
      ) and
      not exists(CompositeAction ancestor, UsesStep caller |
        compositeCaller*(action, ancestor) and
        callsLocalComposite(caller, ancestor) and
        (
          exists(Workflow workflow |
            workflow = caller.getEnclosingWorkflow() and
            not this.pinsInWorkflow(uses, ref, workflow.getLocation().getFile().getRelativePath())
          )
          or
          not exists(caller.getEnclosingWorkflow()) and
          not exists(caller.getEnclosingCompositeAction())
        )
      )
    )
  }
}
