.. _using-range-analsis-in-cpp:

Using range analysis for C and C++
==================================

You can use range analysis to determine the upper or lower bounds on an expression, or whether an expression could potentially over or underflow.

About the range analysis library
--------------------------------

The range analysis library (defined in ``semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis``) provides a set of predicates for determining constant upper and lower bounds on expressions, as well as recognizing integer overflows. For performance, the library performs automatic widening and therefore may not provide the tightest possible bounds.

Bounds predicates
-----------------

The ``upperBound`` and ``lowerBound`` predicates provide constant bounds on expressions. No conversions of the argument are included in the bound. In the common case that your query needs to take conversions into account, call them on the converted form, such as ``upperBound(expr.getFullyConverted())``.

Overflow predicates
-------------------

``exprMightOverflow`` and related predicates hold if the relevant expression might overflow, as determined by the range analysis library. The ``convertedExprMightOverflow`` family of predicates will take conversions into account.

Example
-------

This query uses ``upperBound`` to determine whether the result of ``snprintf`` is checked when used in a loop.

.. code-block:: ql

    from FunctionCall call, DataFlow::Node source, DataFlow::Node sink, Expr convSink
    where
      // the call is an snprintf with a string format argument
      call.getTarget().getName() = "snprintf" and
      call.getArgument(2).getValue().regexpMatch(".*%s.*") and

      // the result of the call influences its size argument in later iterations
      TaintTracking::localTaint(source, sink) and
      source.asExpr() = call and
      sink.asExpr() = call.getArgument(1) and

      // there is no fixed bound on the snprintf's size argument
      upperBound(convSink) = typeUpperBound(convSink.getType().getUnspecifiedType()) and
      convSink = call.getArgument(1).getFullyConverted()

    select call, upperBound(call.getArgument(1).getFullyConverted())

Further reading
---------------

.. include:: ../reusables/cpp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
