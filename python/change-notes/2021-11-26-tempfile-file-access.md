lgtm,codescanning
* Added modeling of the `tempfile` module for creating temporary files and directories, such as the functions `tempfile.NamedTemporaryFile` and `tempfile.TemporaryDirectory`. The `suffix`, `prefix`, and `dir` arguments are all vulnerable to path-injection, and these are new sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
