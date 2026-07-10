/**
 * @name Unpinned tag for a non-immutable Action in workflow or composite action
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

// A `$/` reference is a same-repo self-reference (e.g. `$/path/to/action`), resolved at the
// commit the calling workflow is running. Like `./` local references, it is inherently pinned
// and can never be an unpinned-tag finding, so we never flag it.
bindingset[nwo]
private predicate isSelfReference(string nwo) { nwo.matches("$/%") }

// Holds if `uses` (calling action `nwo` at `version`) is pinned by an entry in the repository's
// Actions lockfile (`.github/workflows/actions.lock`). The underlying `pinnedByLockfileDataModel`
// predicate is populated by the CodeQL Actions extractor when it parses the lockfile at
// database-creation time; until then this is a clean no-op and no lockfile-pinned refs are
// suppressed. See `pinnedByLockfileDataModel` in `ConfigExtensions.qll` for the intended shape.
private predicate pinnedByLockfile(UsesStep uses, string nwo, string version) {
  pinnedByLockfileDataModel(uses.getLocation().getFile().getRelativePath(), nwo, version)
}

private predicate getStepContainerName(UsesStep uses, string name) {
  exists(Workflow workflow |
    uses.getEnclosingWorkflow() = workflow and
    (
      workflow.getName() = name
      or
      not exists(workflow.getName()) and workflow.getLocation().getFile().getBaseName() = name
    )
  )
  or
  exists(CompositeAction action |
    uses.getEnclosingCompositeAction() = action and
    name = action.getLocation().getFile().getBaseName()
  )
}

from UsesStep uses, string nwo, string version, string name
where
  uses.getCallee() = nwo and
  getStepContainerName(uses, name) and
  uses.getVersion() = version and
  not isTrustedOwner(nwo) and
  not isSelfReference(nwo) and
  not pinnedByLockfile(uses, nwo, version) and
  not (if isContainerImage(nwo) then isPinnedContainer(version) else isPinnedCommit(version)) and
  not isImmutableAction(uses, nwo)
select uses.getCalleeNode(),
  "Unpinned 3rd party Action '" + name + "' step $@ uses '" + nwo + "' with ref '" + version +
    "', not a pinned commit hash", uses, uses.toString()
