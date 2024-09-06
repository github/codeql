/**
 * @name Storage of sensitive information in GitHub Actions artifact
 * @description Including sensitive information in a GitHub Actions artifact can
 *              expose it to an attacker.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id actions/secrets-in-artifacts
 * @tags actions
 *       security
 *       external/cwe/cwe-312
 */

import actions

from UsesStep checkout, UsesStep upload
where
  checkout.getCallee() = "actions/checkout" and
  upload.getCallee() = "actions/upload-artifact" and
  checkout.getAFollowingStep() = upload and
  (
    not exists(checkout.getArgument("persist-credentials")) or
    checkout.getArgument("persist-credentials") = "true"
  ) and
  upload.getVersion() =
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
    not exists(checkout.getArgument("path")) and
    upload.getArgument("path") = [".", "*"]
    or
    checkout.getArgument("path") + ["", "/*"] = upload.getArgument("path")
  )
select upload, "A secret is exposed in an artifact uploaded by $@", upload,
  "actions/upload-artifact"
