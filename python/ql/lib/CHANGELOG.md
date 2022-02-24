## 0.0.10

### Deprecated APIs

* The old points-to based modeling has been deprecated. Use the new type-tracking/API-graphs based modeling instead.

## 0.0.9

## 0.0.8

### Deprecated APIs

* Moved the files defining regex injection configuration and customization, instead of `import semmle.python.security.injection.RegexInjection` please use `import semmle.python.security.dataflow.RegexInjection` (the same for `RegexInjectionCustomizations`).
* The `codeql/python-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/python-all` CodeQL pack.

## 0.0.7

## 0.0.6

## 0.0.5

### Minor Analysis Improvements

* Added modeling of many functions from the `os` module that uses file system paths, such as `os.stat`, `os.chdir`, `os.mkdir`, and so on.
* Added modeling of the `tempfile` module for creating temporary files and directories, such as the functions `tempfile.NamedTemporaryFile` and `tempfile.TemporaryDirectory`.
* Extended the modeling of FastAPI such that custom subclasses of `fastapi.APIRouter` are recognized.
* Extended the modeling of FastAPI such that `fastapi.responses.FileResponse` are considered `FileSystemAccess`.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.

## 0.0.4

### Major Analysis Improvements

* Added modeling of `os.stat`, `os.lstat`, `os.statvfs`, `os.fstat`, and `os.fstatvfs`, which are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.
* Added modeling of `aiopg` for sinks executing SQL.
* Added modeling of HTTP requests and responses when using `flask_admin` (`Flask-Admin` PyPI package), which leads to additional remote flow sources.
* Added modeling of the PyPI package `toml`, which provides encoding/decoding of TOML documents, leading to new taint-tracking steps.
