/**
 * Provides a class for modeling functions that return data from potentially untrusted sources. To use
 * this QL library, create a QL class extending `DataFlowFunction` with a
 * characteristic predicate that selects the function or set of functions you
 * are modeling. Within that class, override the predicates provided by
 * `RemoteFlowFunction` to match the flow within that function.
 */

import cpp
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models

/**
 * A library function that returns data that may be read from a network connection.
 */
abstract class RemoteFlowFunction extends Function {
  /**
   * Holds if remote data described by `description` flows from `output` of a call to this function.
   */
  abstract predicate hasRemoteFlowSource(FunctionOutput output, string description);
}

/**
 * A library function that returns data that is directly controlled by a user.
 */
abstract class LocalFlowFunction extends Function {
  /**
   * Holds if data described by `description` flows from `output` of a call to this function.
   */
  abstract predicate hasLocalFlowSource(FunctionOutput output, string description);
}
