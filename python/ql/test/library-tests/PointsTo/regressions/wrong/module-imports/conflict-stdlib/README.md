This test shows how we handle modules that shadow a module in the standard library.

We manually replicate the behavior of `codeql database create --source-root <src-dir>`, which will use `-R <src-dir>`. By default, the way qltest invokes the extractor will cause different behavior. Therefore, we also need to move our code outside of the top-level folder, and it lives in `code-invalid-package-name/` -- notice that if we use `code` as the folder name, the extractor will treat it as if there is a package called `code` (note, `codeql database create` would not treat the folder `code` as a package when `code` is used as the `--source-root`).

The results from `LocalModules.ql`, where everything is a script, matches with the extractor :+1:

Because we have a `cmd.py` file, whenever the python interpreter sees `import cmd`, that is the file that will be used!

* `python test_ok.py` works as intended, and prints `Foo`
* `python test_fail.py` raises an exception, since it imports `pdb.py` from the standard library, which (at least in Python 3.8) tries to import `cmd.py` from the standard library, but instead is served our `cmd.py` module. Therefore it fails with `AttributeError: module 'cmd' has no attribute 'Cmd'`
