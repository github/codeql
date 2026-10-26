---
category: fix
---
* The Go extractor now passes the registry proxy CA certificate to Git subprocesses, allowing private `git_source` modules to be fetched through the proxy.
