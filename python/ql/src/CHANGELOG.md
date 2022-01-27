## 0.0.7

## 0.0.6

### New Queries

* Two new queries have been added for detecting Server-side request forgery (SSRF). _Full server-side request forgery_ (`py/full-ssrf`) will only alert when the URL is fully user-controlled, and _Partial server-side request forgery_ (`py/partial-ssrf`) will alert when any part of the URL is user-controlled. Only `py/full-ssrf` will be run by default.

### Minor Analysis Improvements

* To support the new SSRF queries, the PyPI package `requests` has been modeled, along with `http.client.HTTP[S]Connection` from the standard library.

## 0.0.5

### Minor Analysis Improvements

* Added modeling of many functions from the `os` module that uses file system paths, such as `os.stat`, `os.chdir`, `os.mkdir`, and so on. All of these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `tempfile` module for creating temporary files and directories, such as the functions `tempfile.NamedTemporaryFile` and `tempfile.TemporaryDirectory`. The `suffix`, `prefix`, and `dir` arguments are all vulnerable to path-injection, and these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Extended the modeling of FastAPI such that `fastapi.responses.FileResponse` are considered `FileSystemAccess`, making them sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of the `posixpath`, `ntpath`, and `genericpath` modules for path operations (although these are not supposed to be used), resulting in new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
* Added modeling of `wsgiref.simple_server` applications, leading to new remote flow sources.

## 0.0.4

### Query Metadata Changes

* Fixed the query ids of two queries that are meant for manual exploration: `python/count-untrusted-data-external-api` and `python/untrusted-data-to-external-api` have been changed to `py/count-untrusted-data-external-api` and `py/untrusted-data-to-external-api`.
