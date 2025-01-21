---
category: minorAnalysis
---
* `JavacTool`-based compiler interception no longer requires an `--add-opens` directive when `FileObject.toUri` is accessible.
* `JavacTool`-based compiler interception no longer throws an exception visible to the program using `JavacTool` on failure to extract a file path from a passed `JavaFileObject`.
* `JavacTool`-based compiler interception now supports files that don't simply wrap a `file://` URL, such as a source file inside a JAR, or an in-memory file, but which do implement `getCharContent`.
