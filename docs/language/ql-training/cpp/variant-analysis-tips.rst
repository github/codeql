================================
Variant analysis tips and tricks
================================

QL for C/C++

.. container:: semmle-logo

   Semmle :sup:`TM`

.. rst-class:: agenda

Agenda
======

- Range analysis
- Guards

Range analysis
==============

*Range analysis* is the process of determining upper and lower bounds for arithmetic values in the program.

  .. code-block:: cpp

    void f(int x) {
      if (x < -1 || x > 16) {
        return;
      }
      val[x]; // What possible values can x hold here?
    }

Simple range analysis
=====================

The standard libraries include the ``semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis`` QL library. This determines, where possible, fixed bounds for an arithmetic expression.

  .. code-block:: ql

    import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

    from ArrayExpr ae
    where lowerBound(ae.getArrayOffset()) < 0
    select ae


Simple range analysis: use cases
================================

This library only supports *constant* bounds - it will return a 

The Semmle C/C++ standard library includes the ``SimpleRangeAnalysis`` .


Guards
======

*Guards* are conditions which