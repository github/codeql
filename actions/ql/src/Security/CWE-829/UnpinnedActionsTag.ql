/**
 * @name Unpinned tag for a non-immutable Action or reusable workflow
 * @description Using a mutable reference for a non-immutable Action or reusable workflow can lead to executing untrusted code through a supply chain attack.
 * @kind problem
 * @security-severity 5.0
 * @problem.severity warning
 * @precision medium
 * @id actions/unpinned-tag
 * @tags security
 *       actions
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.UseOfUnversionedImmutableAction

bindingset[version]
private predicate isPinnedCommit(string version) {
  version.regexpMatch("^[A-Fa-f0-9]{40}([A-Fa-f0-9]{24})?$")
}

bindingset[nwo]
private predicate isTrustedOwner(string nwo) {
  // Gets the segment before the first '/' in the name with owner(nwo) string
  trustedActionsOwnerDataModel(nwo.substring(0, nwo.indexOf("/")))
}

bindingset[version]
private predicate isPinnedContainer(string version) {
  version.regexpMatch("^sha256:[A-Fa-f0-9]{64}$")
}

bindingset[nwo]
private predicate isContainerImage(string nwo) { nwo.regexpMatch("^docker://.+") }

private predicate hasUsesContainerName(Uses uses, string name) {
  exists(Workflow workflow |
    uses.getEnclosingWorkflow() = workflow and
    (
      workflow.getName() = name
      or
      not exists(workflow.getName()) and workflow.getLocation().getFile().getBaseName() = name
    )
  )
  or
  exists(UsesStep step, CompositeAction action |
    uses = step and
    step.getEnclosingCompositeAction() = action and
    name = action.getLocation().getFile().getBaseName()
  )
}

from Uses uses, string nwo, string version, string name, string message
where
  uses.getCallee() = nwo and
  hasUsesContainerName(uses, name) and
  uses.getVersion() = version and
  not isTrustedOwner(nwo) and
  not (
    if uses instanceof UsesStep and isContainerImage(nwo)
    then isPinnedContainer(version)
    else isPinnedCommit(version)
  ) and
  not exists(UsesStep step | uses = step and isImmutableAction(step, nwo)) and
  if uses instanceof ExternalJob
  then
    message =
      "Job $@ in '" + name + "' uses reusable workflow '" + nwo + "' with ref '" + version +
        "', not a pinned commit hash"
  else
    message =
      "Unpinned 3rd party Action '" + name + "' step $@ uses '" + nwo + "' with ref '" + version +
        "', not a pinned commit hash"
select uses.getCalleeNode(), message, uses, uses.toString()
