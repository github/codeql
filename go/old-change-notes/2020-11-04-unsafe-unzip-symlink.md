lgtm,codescanning
* A new query `go/unsafe-unzip-symlink` has been added. The query checks for extracting symbolic links from an archive without using `filepath.EvalSymlinks`. This could lead to a file being written outside the destination directory.
