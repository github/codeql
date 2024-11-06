These files can only be updated having access for the internal repository at the moment.

In order to perform a Swift update:

1. Dispatch the [internal `swift-prebuild` workflow](https://github.com/github/semmle-code/actions/workflows/__swift-prebuild.yml) with the appropriate swift
   tag.
2. Dispatch [internal `swift-prepare-resource-dir` workflow](https://github.com/github/semmle-code/actions/workflows/__swift-prepare-resource-dir.yml) with the
   appropriate swift tag.
3. Once the jobs finish, staged artifacts are available
   at https://github.com/dsp-testing/codeql-swift-artifacts/releases. Copy and paste the sha256 within the `_override`
   definition in [`load.bzl`](../load.bzl).
4. Compile and run test locally. Adjust the code if needed. New AST entities have to be dealt with in [
   `SwiftTagTraits.h`](../../extractor/infra/SwiftTagTraits.h).
5. Open a draft PR with the overridden artifacts. Make sure CI passes, go back to 4. otherwise.
6. Run DCA, got back to 4. in case of problems.
7. Once you are happy, do
   ```bash
   bazel run //swift/third_party/resources:update-dir-macos
   bazel run //swift/third_party/resources:update-dir-linux
   bazel run //swift/third_party/resources:update-prebuilt-macos
   bazel run //swift/third_party/resources:update-prebuilt-linux
   ```
   (or whatever you have overridden). This will pull the staged archives in the repository for git LFS.
8. Clear `_override` in [`load.bzl`](../load.bzl).
9. Push and your PR will be ready for `main`.
