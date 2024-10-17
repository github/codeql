/**
 * @name Unversioned Immutable Action
 * @description Using an Immutable Action without a semantic version tag opts out of the protections of Immutable Action
 * @kind problem
 * @security-severity 5.0
 * @problem.severity recommendation
 * @precision high
 * @id actions/unversioned-immutable-action
 * @tags security
 *       actions
 *       external/cwe/cwe-829
 */

import actions

bindingset[version]
private predicate isSemanticVersioned(string version) { version.regexpMatch("^v[0-9]+(\\.[0-9]+)*(\\.[xX])?$") }

bindingset[repo]
private predicate isTrustedOrg(string repo) {
  exists(string org | org in ["actions", "github", "advanced-security", "octokit"] | repo.matches(org + "/%"))
}

from UsesStep uses, string repo, string version, Workflow workflow, string name
where
  uses.getCallee() = repo and
  uses.getEnclosingWorkflow() = workflow and
  (
    workflow.getName() = name
    or
    not exists(workflow.getName()) and workflow.getLocation().getFile().getBaseName() = name
  ) and
  uses.getVersion() = version and
  not isTrustedOrg(repo) and
  not isPinnedCommit(version)
select uses.getCalleeNode(),
  "Unpinned 3rd party Action '" + name + "' step $@ uses '" + repo + "' with ref '" + version +
    "', not a pinned commit hash", uses, uses.toString()
