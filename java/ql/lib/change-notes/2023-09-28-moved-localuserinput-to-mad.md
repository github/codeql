---
category: minorAnalysis
---
* Modified the `EnvInput` class in `semmle.code.java.dataflow.FlowSources` to include `environment` and `file` source nodes.
* Added `environment` source models for the following methods:
  * `java.lang.System#getenv`
  * `java.lang.System#getProperties`
  * `java.lang.System#getProperty`
  * `java.util.Properties#get`
  * `java.util.Properties#getProperty`
* Added `file` source models for the following methods:
  * the `java.io.FileInputStream` constructor
  * `hudson.FilePath#newInputStreamDenyingSymlinkAsNeeded`
  * `hudson.FilePath#openInputStream`
  * `hudson.FilePath#read`
  * `hudson.FilePath#readFromOffset`
  * `hudson.FilePath#readToString`
* Modified the `DatabaseInput` class in `semmle.code.java.dataflow.FlowSources` to include `database` source nodes.
* Added `database` source models for the following method:
  * `java.sql.ResultSet#getString`
