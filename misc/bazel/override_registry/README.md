This was taken from https://github.com/bazelbuild/bazel-central-repository and readapted:
* The latest version was renamed with a `-patched` suffix
* The above rename was done also in the files:
   * `modules/rules_kotlin/metadata.json`
   * `module/rules_kotlin/1.9.4-patched/MODULE.bazel`
* `modules/rules_kotlin/1.9.4-patched/patches/add_language_version_option.patch` was added
* the above patch was added in `modules/rules_kotlin/1.9.4-patched/source.json`, with integrity SHAs generated via
  `echo -n sha256-; cat <file> | openssl dgst -sha256 -binary | base64`.
