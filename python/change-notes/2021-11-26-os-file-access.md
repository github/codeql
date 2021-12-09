lgtm,codescanning
* Added modeling of many functions from the `os` module that uses file system paths, such as `os.stat`, `os.chdir`, `os.mkdir`, and so on. All of these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
