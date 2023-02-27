/**
 * For internal use only.
 *
 * Defines the set of classes that endpoint scoring models can predict. Endpoint scoring models must
 * only predict classes defined within this file. This file is the source of truth for the integer
 * representation of each of these classes.
 */

/** A class that can be predicted by a classifier. */
abstract class EndpointType extends string {
  /**
   * Holds when the string matches the name of the sink / source type.
   */
  bindingset[this]
  EndpointType() { any() }

  final string getDescription() { result = this }

  /**
   * Gets the name of the sink/source kind for this endpoint type as used in Models as Data.
   *
   * See https://github.com/github/codeql/blob/44213f0144fdd54bb679ca48d68b28dcf820f7a8/java/ql/lib/semmle/code/java/dataflow/ExternalFlow.qll#LL353C11-L357C31
   */
  abstract string getKind();
}

/** A class for sink types that can be predicted by a classifier. */
abstract class SinkType extends EndpointType {
  bindingset[this]
  SinkType() { any() }
}

/** A class for source types that can be predicted by a classifier. */
abstract class SourceType extends EndpointType {
  bindingset[this]
  SourceType() { any() }
}

/** The `Negative` class for non-sinks. */
class NegativeSinkType extends SinkType {
  NegativeSinkType() { this = "non-sink" }

  override string getKind() { result = "" }
}

/** All sinks relevant to the SQL injection query */
class SqlSinkType extends SinkType {
  SqlSinkType() { this = "sql injection sink" }

  override string getKind() { result = "sql" }
}

/** All sinks relevant to the tainted path injection query. */
class TaintedPathSinkType extends SinkType {
  TaintedPathSinkType() { this = "path injection sink" }

  override string getKind() { result = "tainted-path" }
}

/** All sinks relevant to the SSRF query. */
class RequestForgerySinkType extends SinkType {
  RequestForgerySinkType() { this = "ssrf sink" }

  override string getKind() { result = "ssrf" }
}

/** Other sinks modeled by a MaD `kind` but not belonging to any of the existing sink types. */
class OtherMaDSinkType extends SinkType {
  OtherMaDSinkType() { this = "other sink" }

  override string getKind() { result = "other-sink" }
}
