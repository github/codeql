/** Provides classes associated with logging frameworks. */
overlay[local?]
module;

import csharp

/** A logger type that extends from an `ILogger` type. */
class LoggerType extends RefType {
  LoggerType() { this.getABaseType*().hasName("ILogger") }
}
