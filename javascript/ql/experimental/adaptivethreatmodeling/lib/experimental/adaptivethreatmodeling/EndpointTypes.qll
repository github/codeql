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
  TShellCommandInjectionFromEnvironmentSinkType()

/** A class that can be predicted by endpoint scoring models. */
abstract class EndpointType extends TEndpointType {
  abstract string getDescription();

  /**
   * Gets the integer representation of this endpoint type. This integer representation specifies the class number
   * used by the endpoint scoring model (the classifier) to represent this endpoint type. Class 0 is the negative
   * class (non-sink). Each positive int corresponds to a single sink type.
   */
  abstract int getEncoding();

  string toString() { result = getDescription() }
}

/** The `Negative` class that can be predicted by endpoint scoring models. */
class NegativeType extends EndpointType, TNegativeType {
  override string getDescription() { result = "Negative" }

  override int getEncoding() { result = 0 }
}

/** The `XssSink` class that can be predicted by endpoint scoring models. */
class XssSinkType extends EndpointType, TXssSinkType {
  override string getDescription() { result = "XssSink" }

  override int getEncoding() { result = 1 }
}

/** The `NosqlInjectionSink` class that can be predicted by endpoint scoring models. */
class NosqlInjectionSinkType extends EndpointType, TNosqlInjectionSinkType {
  override string getDescription() { result = "NosqlInjectionSink" }

  override int getEncoding() { result = 2 }
}

/** The `SqlInjectionSink` class that can be predicted by endpoint scoring models. */
class SqlInjectionSinkType extends EndpointType, TSqlInjectionSinkType {
  override string getDescription() { result = "SqlInjectionSink" }

  override int getEncoding() { result = 3 }
}

/** The `TaintedPathSink` class that can be predicted by endpoint scoring models. */
class TaintedPathSinkType extends EndpointType, TTaintedPathSinkType {
  override string getDescription() { result = "TaintedPathSink" }

  override int getEncoding() { result = 4 }
}

/** The `ShellCommandInjectionFromEnvironmentSink` class that can be predicted by endpoint scoring models. */
class ShellCommandInjectionFromEnvironmentSinkType extends EndpointType,
  TShellCommandInjectionFromEnvironmentSinkType
{
  override string getDescription() { result = "ShellCommandInjectionFromEnvironmentSink" }

  override int getEncoding() { result = 5 }
}
