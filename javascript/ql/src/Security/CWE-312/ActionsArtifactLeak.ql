/**
 * @name Storage of sensitive information in GitHub Actions artifact
 * @description Including sensitive information in a GitHub Actions artifact can
 *              expose it to an attacker.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/actions/actions-artifact-leak
 * @tags actions
 *       security
 *       external/cwe/cwe-312
 *       external/cwe/cwe-315
 *       external/cwe/cwe-359
 */

import javascript
import semmle.javascript.Actions

/**
 * A step that uses `actions/checkout` action.
 */
class ActionsCheckoutStep extends Actions::Step {
  ActionsCheckoutStep() { this.getUses().getGitHubRepository() = "actions/checkout" }
}

/**
 * A `with:`/`persist-credentials` field sibling to `uses: actions/checkout`.
 */
class ActionsCheckoutWithPersistCredentials extends YamlNode, YamlScalar {
  ActionsCheckoutStep step;

  ActionsCheckoutWithPersistCredentials() {
    step.lookup("with").(YamlMapping).lookup("persist-credentials") = this
  }

  /** Gets the step this field belongs to. */
  ActionsCheckoutStep getStep() { result = step }
}

/**
 * A `with:`/`path` field sibling to `uses: actions/checkout`.
 */
class ActionsCheckoutWithPath extends YamlNode, YamlString {
  ActionsCheckoutStep step;

  ActionsCheckoutWithPath() { step.lookup("with").(YamlMapping).lookup("path") = this }

  /** Gets the step this field belongs to. */
  ActionsCheckoutStep getStep() { result = step }
}

/**
 * A step that uses `actions/upload-artifact` action.
 */
class ActionsUploadArtifactStep extends Actions::Step {
  ActionsUploadArtifactStep() { this.getUses().getGitHubRepository() = "actions/upload-artifact" }
}

/**
 * A `with:`/`path` field sibling to `uses: actions/upload-artifact`.
 */
class ActionsUploadArtifactWithPath extends YamlNode, YamlString {
  ActionsUploadArtifactStep step;

  ActionsUploadArtifactWithPath() { step.lookup("with").(YamlMapping).lookup("path") = this }

  /** Gets the step this field belongs to. */
  ActionsUploadArtifactStep getStep() { result = step }
}

from ActionsCheckoutStep checkout, ActionsUploadArtifactStep upload, Actions::Job job, int i, int j
where
  checkout.getJob() = job and
  upload.getJob() = job and
  job.getStep(i) = checkout and
  job.getStep(j) = upload and
  j = i + 1 and
  upload.getUses().getVersion() =
    [
      "v4.3.6", "834a144ee995460fba8ed112a2fc961b36a5ec5a", //
      "v4.3.5", "89ef406dd8d7e03cfd12d9e0a4a378f454709029", //
      "v4.3.4", "0b2256b8c012f0828dc542b3febcab082c67f72b", //
      "v4.3.3", "65462800fd760344b1a7b4382951275a0abb4808", //
      "v4.3.2", "1746f4ab65b179e0ea60a494b83293b640dd5bba", //
      "v4.3.1", "5d5d22a31266ced268874388b861e4b58bb5c2f3", //
      "v4.3.0", "26f96dfa697d77e81fd5907df203aa23a56210a8", //
      "v4.2.0", "694cdabd8bdb0f10b2cea11669e1bf5453eed0a6", //
      "v4.1.0", "1eb3cb2b3e0f29609092a73eb033bb759a334595", //
      "v4.0.0", "c7d193f32edcb7bfad88892161225aeda64e9392", //
    ] and
  (
    not exists(ActionsCheckoutWithPersistCredentials persist | persist.getStep() = checkout)
    or
    exists(ActionsCheckoutWithPersistCredentials persist |
      persist.getStep() = checkout and
      persist.getValue() = "true"
    )
  ) and
  (
    not exists(ActionsCheckoutWithPath path | path.getStep() = checkout) and
    exists(ActionsUploadArtifactWithPath path |
      path.getStep() = upload and path.getValue() = [".", "*"]
    )
    or
    exists(ActionsCheckoutWithPath checkout_path, ActionsUploadArtifactWithPath upload_path |
      checkout_path.getValue() + ["", "/*"] = upload_path.getValue() and
      checkout_path.getStep() = checkout and
      upload_path.getStep() = upload
    )
  )
select upload, "A secret may be exposed in an artifact."
