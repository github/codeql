/**
 * @name Unpinned tag for a non-immutable Action in workflow
 * @description Using a tag for a non-immutable Action that is not pinned to a commit can lead to executing an untrusted Action through a supply chain attack.
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
private predicate isPinnedCommit(string version) { version.regexpMatch("^[A-Fa-f0-9]{40}$") }

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

from UsesStep uses, string nwo, string version, Workflow workflow, string name
where
  uses.getCallee() = nwo and
  uses.getEnclosingWorkflow() = workflow and
  (
    workflow.getName() = name
    or
    not exists(workflow.getName()) and workflow.getLocation().getFile().getBaseName() = name
  ) and
  uses.getVersion() = version and
  not isTrustedOwner(nwo) and
  not (if isContainerImage(nwo) then isPinnedContainer(version) else isPinnedCommit(version)) and
  not isImmutableAction(uses, nwo)
select uses.getCalleeNode(),
  "Unpinned 3rd party Action '" + name + "' step $@ uses '" + nwo + "' with ref '" + version +
    "', not a pinned commit hash", uses, uses.toString()
