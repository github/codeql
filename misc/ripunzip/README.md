These LFS files are distributions of [ripunzip](https://github.com/google/ripunzip), compiled with this [workflow](https://github.com/github/codeql/actions/workflows/build-ripunzip.yml).
A [copy](./LICENSE.txt) of the ripunzip license is included.

`ripunzip` can easily be made available on the system by running
```bash
bazel run //misc/ripunzip:install
```
By default, it will be installed in `~/.local/bin`. The target can be changed with
```bash
bazel run //misc/ripunzip:install -- /path/to/installation/dir
```
