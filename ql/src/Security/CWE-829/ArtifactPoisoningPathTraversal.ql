/**
 * @name Artifact Poisoning (Path Traversal).
 * @description An attacker may be able to poison the workflow's artifacts and influence on consequent steps.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @security-severity 9
 * @id actions/artifact-poisoning/path-traversal
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.PoisonableSteps

from UsesStep download
where
  download.getCallee() = "actions/download-artifact" and
  download.getCallee() = "actions/download-artifact" and
  (
    download.getVersion() =
      [
        "4.1.6", "4.1.5", "4.1.4", "4.1.3", "4.1.2", "4.1.1", "4.1.0", "4.0.0", "3.0.2", "3.0.1",
        "3.0.0", "3", "3-node20", "2.1.1", "2.1.0", "2.0.10", "2.0.9", "2.0.8", "2.0.7", "2.0.6",
        "2.0.5", "2.0.4", "2.0.3", "2.0.2", "2.0.1", "2.0", "2", "1.0.0", "1", "1.0.0",
      ]
    or
    download
        .getVersion()
        .matches([
              "9c19ed7f", "8caf195a", "c850b930", "87c55149", "eaceaf80", "6b208ae0", "f44cd7b4",
              "7a1cd321", "9bc31d5c", "9782bd6a", "fb598a63", "9bc31d5c", "246d7188", "cbed621e",
              "f023be2c", "3be87be1", "158ca71f", "4a7a7112", "f144d3c3", "f8e41fbf", "c3f5d00c",
              "b3cedea9", "80d2d402", "381af06b", "1ac47ba4", "1de1dea8", "cbed621e", "18f0f591",
              "18f0f591", "18f0f591",
            ] + "%")
  ) and
  (
    // exists a poisonable upload artifact in the same workflow
    exists(UsesStep checkout, PoisonableStep poison, UsesStep upload |
      download.getEnclosingWorkflow().getAJob().(LocalJob).getAStep() = checkout and
      download.getEnclosingJob().isPrivilegedExternallyTriggerable() and
      checkout.getCallee() = "actions/checkout" and
      checkout.getAFollowingStep() = poison and
      poison.getAFollowingStep() = upload and
      upload.getCallee() = "actions/upload-artifact"
    )
    or
    // upload artifact is not used in the same workflow
    not exists(UsesStep upload |
      download.getEnclosingWorkflow().getAJob().(LocalJob).getAStep() = upload
    )
  )
select download, "Potential artifact poisoning"
