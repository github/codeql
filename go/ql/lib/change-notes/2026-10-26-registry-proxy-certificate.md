---
category: fix
---
* The Go extractor no longer modifies the global Git configuration when private `git_source` registries are configured. The registry proxy certificate is now passed to Git through the `GIT_SSL_CAINFO` environment variable instead, which only affects the Git processes spawned by `go`.
