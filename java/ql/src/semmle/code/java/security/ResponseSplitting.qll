import semmle.code.java.dataflow.DataFlow

/**
 * Header-splitting sinks. Expressions that end up in an HTTP header.
 */
abstract class HeaderSplittingSink extends DataFlow::Node { }

/**
 * Sources that cannot be used to perform a header splitting attack.
 */
abstract class SafeHeaderSplittingSource extends DataFlow::Node { }
