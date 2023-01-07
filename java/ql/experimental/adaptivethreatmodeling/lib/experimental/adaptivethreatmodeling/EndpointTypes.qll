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
  TSqlInjectionSinkType() or
  TTaintedPathSinkType() or
  TRequestForgerySinkType()

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

/** The `Negative` class that can be predicted by endpoint scoring models. */
class NegativeType extends EndpointType, TNegativeType {
  override string getDescription() { result = "non-sink" }

  override int getEncoding() { result = 0 }

  override string getKind() { result = "" }
}

/** The `XssSink` class that can be predicted by endpoint scoring models. */
class XssSinkType extends EndpointType, TXssSinkType {
  override string getDescription() { result = "xss sink" }

  override int getEncoding() { result = 1 }

  override string getKind() { result = "xss" }
}

/** The `SqlInjectionSink` class that can be predicted by endpoint scoring models. */
class SqlInjectionSinkType extends EndpointType, TSqlInjectionSinkType {
  override string getDescription() { result = "sql injection sink" }

  override int getEncoding() { result = 3 }

  override string getKind() { result = "sql" }
}

/** The `TaintedPathSink` class that can be predicted by endpoint scoring models. */
class TaintedPathSinkType extends EndpointType, TTaintedPathSinkType {
  override string getDescription() { result = "path injection sink" }

  override int getEncoding() { result = 4 }

  override string getKind() { result = "create-file" }
}

/** The `RequestForgerySinkType` class that can be predicted by endpoint scoring models. */
class RequestForgerySinkType extends EndpointType, TRequestForgerySinkType {
  override string getDescription() { result = "server-side request forgery sink" }

  override int getEncoding() { result = 5 }

  override string getKind() { result = "open-url" } // TODO: is this correct, or should it be “jdbc-url”?
}
