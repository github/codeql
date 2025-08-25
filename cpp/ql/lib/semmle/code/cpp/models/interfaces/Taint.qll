/**
 * Provides an abstract class for accurate taint modeling of library
 * functions when source code is not available.  To use this QL library,
 * create a QL class extending `TaintFunction` with a characteristic predicate
 * that selects the function or set of functions you are modeling. Within that
 * class, override the predicates provided by `TaintFunction` to match the flow
 * within that function.
 */

import semmle.code.cpp.Function
import FunctionInputsAndOutputs
import semmle.code.cpp.models.Models
import PartialFlow

/**
 * A library function for which a taint-tracking library should propagate taint
 * from a parameter or qualifier to an output buffer, return value, or qualifier.
 *
 * An expression is tainted if it could be influenced by an attacker to have
 * an unusual value.
 *
 * Note that this does not include direct copying of values; that is covered by
 * DataFlowModel.qll. If a value is sometimes copied in full, and sometimes
 * altered (for example copying a string with `strncpy`), this is also considered
 * data flow.
 */
abstract class TaintFunction extends PartialFlowFunction {
  /**
   * Holds if data passed into the argument, qualifier, or buffer represented by
   * `input` influences the return value or buffer represented by `output`
   */
  pragma[nomagic]
  abstract predicate hasTaintFlow(FunctionInput input, FunctionOutput output);
}
