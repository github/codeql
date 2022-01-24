/**
 * Provides classes for modeling functions that return data from (or send data to) potentially untrusted
 * sources. To use this QL library, create a QL class extending `DataFlowFunction` with a
 * characteristic predicate that selects the function or set of functions you
 * are modeling. Within that class, override the predicates provided by
 * `RemoteFlowSourceFunction` or `RemoteFlowSinkFunction` to match the flow within that function.
 */

import cpp
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

/**
 * A library function that returns data that may be read from a network connection.
 */
abstract class RemoteFlowSourceFunction extends Function {
  /**
   * Holds if remote data described by `description` flows from `output` of a call to this function.
   */
  abstract predicate hasRemoteFlowSource(FunctionOutput output, string description);

  /**
   * Holds if remote data from this source comes from a socket or stream
   * described by `input`. There is no result if none is specified by a
   * parameter.
   */
  predicate hasSocketInput(FunctionInput input) { none() }
}

/**
 * DEPRECATED: Use `RemoteFlowSourceFunction` instead.
 *
 * A library function that returns data that may be read from a network connection.
 */
deprecated class RemoteFlowFunction = RemoteFlowSourceFunction;

/**
 * A library function that returns data that is directly controlled by a user.
 */
abstract class LocalFlowSourceFunction extends Function {
  /**
   * Holds if data described by `description` flows from `output` of a call to this function.
   */
  abstract predicate hasLocalFlowSource(FunctionOutput output, string description);
}

/**
 * DEPRECATED: Use `LocalFlowSourceFunction` instead.
 *
 * A library function that returns data that is directly controlled by a user.
 */
deprecated class LocalFlowFunction = LocalFlowSourceFunction;

/** A library function that sends data over a network connection. */
abstract class RemoteFlowSinkFunction extends Function {
  /**
   * Holds if data described by `description` flows into `input` to a call to this function, and is then
   * send over a network connection.
   */
  abstract predicate hasRemoteFlowSink(FunctionInput input, string description);

  /**
   * Holds if data put into this sink is transmitted through a socket or stream
   * described by `input`. There is no result if none is specified by a
   * parameter.
   */
  predicate hasSocketInput(FunctionInput input) { none() }
}
