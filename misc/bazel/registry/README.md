Versions to be patched can be taken from https://github.com/bazelbuild/bazel-central-repository. After adding patches
inside `<repo>/<version>/patches`, and eventually renaming `<version>`, run [`fix.py`](./fix.py) to align all metadata
to the renamed version and added patches.
