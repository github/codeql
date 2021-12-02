lgtm,codescanning
* Extended the modeling of FastAPI such that `fastapi.responses.FileResponse` are considered `FileSystemAccess`, making them sinks for the _Uncontrolled data used in path expression_ (`py/path-injection`) query.
