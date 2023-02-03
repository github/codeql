/**
 * For internal use only.
 *
 * Defines the set of classes that endpoint scoring models can predict. Endpoint scoring models must
 * only predict classes defined within this file. This file is the source of truth for the integer
 * representation of each of these classes.
 */
newtype TEndpointType =
  TNegativeType() or
  TXssSinkType() or
  TNosqlInjectionSinkType() or
  TSqlInjectionOtherSinkType() or
  TTaintedPathOtherSinkType() or
  TRequestForgeryOtherSinkType() or
  TUrlOpenSinkType() or
  TJdbcUrlSinkType() or
  TCreateFileSinkType() or
  TSqlSinkType()

/** A class that can be predicted by endpoint scoring models. */
abstract class EndpointType extends TEndpointType {
  abstract string getDescription();

  /**
   * Gets the integer representation of this endpoint type. This integer representation specifies the class number
   * used by the endpoint scoring model (the classifier) to represent this endpoint type. Class 0 is the negative
   * class (non-sink). Each positive int corresponds to a single sink type.
   */
  abstract int getEncoding();

  /**
   * Gets the name of the sink/source kind for this endpoint type as used in Models as Data.
   *
   * See https://github.com/github/codeql/blob/44213f0144fdd54bb679ca48d68b28dcf820f7a8/java/ql/lib/semmle/code/java/dataflow/ExternalFlow.qll#LL353C11-L357C31
   */
  abstract string getKind();

  string toString() { result = getDescription() }
}

/** The `Negative` class for non-sinks. */
class NegativeType extends EndpointType, TNegativeType {
  override string getDescription() { result = "non-sink" }

  override int getEncoding() { result = 0 }

  override string getKind() { result = "" }
}

/** Sinks of MaD kind `sql` */
class SqlSinkType extends EndpointType, TSqlSinkType {
  override string getDescription() { result = "sql injection sink" }

  override int getEncoding() { result = 1 }

  override string getKind() { result = "sql" }
}

/** Other SQL injection sinks that are not yet included in the MaD sink kinds. */
class SqlInjectionOtherSinkType extends EndpointType, TSqlInjectionOtherSinkType {
  override string getDescription() {
    result = "java persistence or mongodb or other query injection sink"
  }

  override int getEncoding() { result = 2 }

  override string getKind() { result = "sql-other" }
}

/** Sinks of MaD kind `create-file` */
class CreateFileSinkType extends EndpointType, TCreateFileSinkType {
  override string getDescription() { result = "file creation sink" }

  override int getEncoding() { result = 3 }

  override string getKind() { result = "create-file" }
}

/** Other tainted path injection sinks that are not yet included in the MaD sink kinds. */
class TaintedPathOtherSinkType extends EndpointType, TTaintedPathOtherSinkType {
  override string getDescription() { result = "other path injection sink" }

  override int getEncoding() { result = 4 }

  override string getKind() { result = "tainted-path-other" }
}

/** Sinks of MaD kind `open-url`. */
class UrlOpenSinkType extends EndpointType, TUrlOpenSinkType {
  override string getDescription() { result = "url opening sink" }

  override int getEncoding() { result = 5 }

  override string getKind() { result = "open-url" }
}

/** Sinks of MaD kind `jdbc-url`. */
class JdbcUrlSinkType extends EndpointType, TJdbcUrlSinkType {
  override string getDescription() { result = "jdbc url sink" } // TODO: What's a good description of this sink type?

  override int getEncoding() { result = 6 }

  override string getKind() { result = "jdbc-url" }
}

/**
 * Other SSRF sinks that are not yet included in the MaD sink kinds.
 */
class RequestForgeryOtherSinkType extends EndpointType, TRequestForgeryOtherSinkType {
  override string getDescription() { result = "other server-side request forgery sink" }

  override int getEncoding() { result = 7 }

  override string getKind() { result = "ssrf-other" }
}
