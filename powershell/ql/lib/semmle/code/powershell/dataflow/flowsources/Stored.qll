/**
 * Provides classes representing sources of stored data.
 */

import powershell
private import FlowSources

/** A data flow source of stored user input. */
abstract class StoredFlowSource extends SourceNode {
  override string getThreatModel() { result = "local" }
}

/**
 * A node with input from a database.
 */
abstract class DatabaseInputSource extends StoredFlowSource {
  override string getThreatModel() { result = "database" }

  override string getSourceType() { result = "database input" }
}

private class ExternalDatabaseInputSource extends DatabaseInputSource {
  ExternalDatabaseInputSource() { this = ModelOutput::getASourceNode("database", _).asSource() }
}

/** A file stream source is considered a stored flow source. */
abstract class FileStreamStoredFlowSource extends StoredFlowSource {
  override string getThreatModel() { result = "file" }

  override string getSourceType() { result = "file stream" }
}

private class ExternalFileStreamStoredFlowSource extends FileStreamStoredFlowSource {
  ExternalFileStreamStoredFlowSource() { this = ModelOutput::getASourceNode("file", _).asSource() }
}
