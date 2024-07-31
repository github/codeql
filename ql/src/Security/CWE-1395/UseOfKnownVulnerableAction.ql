/**
 * @name Use of known vulnerable 3rd party action.
 * @description The workflow is using a known vulnerable 3rd party action.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id actions/vulnerable-action
 * @tags actions
 *       security
 *       external/cwe/cwe-1395
 */

import actions

//  gh api /repos/actions/download-artifact/tags --jq 'map({name: .name, sha: .commit.sha})' --paginate
from UsesStep step
where
  step.getCallee() = "actions/download-artifact" and
  (
    step.getVersion() =
      [
        "4.1.6", "4.1.5", "4.1.4", "4.1.3", "4.1.2", "4.1.1", "4.1.0", "4.0.0", "3.0.2", "3.0.1",
        "3.0.0", "3", "3-node20", "2.1.1", "2.1.0", "2.0.10", "2.0.9", "2.0.8", "2.0.7", "2.0.6",
        "2.0.5", "2.0.4", "2.0.3", "2.0.2", "2.0.1", "2.0", "2", "1.0.0", "1", "1.0.0",
      ]
    or
    step.getVersion()
        .matches([
              "9c19ed7f", "8caf195a", "c850b930", "87c55149", "eaceaf80", "6b208ae0", "f44cd7b4",
              "7a1cd321", "9bc31d5c", "9782bd6a", "fb598a63", "9bc31d5c", "246d7188", "cbed621e",
              "f023be2c", "3be87be1", "158ca71f", "4a7a7112", "f144d3c3", "f8e41fbf", "c3f5d00c",
              "b3cedea9", "80d2d402", "381af06b", "1ac47ba4", "1de1dea8", "cbed621e", "18f0f591",
              "18f0f591", "18f0f591",
            ] + "%")
  )
select step, "The workflow is using a known vulnerable version ($@) of the $@ action.", step,
  step.getVersion(), step, step.getCallee()
