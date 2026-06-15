================================
Variant analysis tips and tricks
================================

C/C++

.. container:: semmle-logo

   Semmle :sup:`TM`

.. rst-class:: agenda

Agenda
======

- Query development process
   - Sources of query ideas
   - Evaluating query ideas
   - Iterative query development
- Useful libraries for C/C++
   - Range analysis
   - Guards

.. rst-class:: background2

Query development process
==========================

Sources of ideas
================

- Fix commits in revision history
- Issue reports
- Newly discovered kind of vulnerability
- Transfer from other languages/frameworks
- Chance discovery while working on another query
- Follow Twitter, Hacker News, Snyk, etc.

Evaluating a query idea
=======================

- It should be *specific* e.g. not "find all buffer overflows".
- ...but not too specific, only worthwhile if there are some variants to find!
- There should be a concrete test case exhibiting the problem.

Iterative query development
===========================

- Start with a very specific query that just finds the original bug/test case
- Generalize to get at the essence of the problem
- This also helps forming a better understanding of the problem: “thinking in QL”
- As you generalize, vet new results and refine the query to exclude false positives.
- Ideally, the query should not flag the fixed version (if any).

.. rst-class:: background2

Useful libraries for C/C++
==========================

Range analysis
==============

*Range analysis* is the process of determining upper and lower bounds for arithmetic values in the program.

  .. literalinclude:: ../query-examples/cpp/variant-analysis/range-analysis/test.c
     :language: cpp

This is typically useful for determining underflow, overflow or out of bounds reads/writes.

Simple range analysis
=====================

QL comes with the ``SimpleRangeAnalysis`` library, which can be used to determine, where possible, *fixed bounds* for
an arithmetic expression. For example:

  .. literalinclude:: ../query-examples/cpp/variant-analysis/range-analysis/SimpleIndexOutOfBounds.ql
     :language: ql

Would find the ``val[x]`` access from the previous slide.

Simple range analysis: API
==========================

- ``lowerBound`` and ``upperBound`` predicates provide lower and upper bounds on expressions, where possible.
- ``exprWithEmptyRange`` predicate identifies expressions which have non-overlapping upper and lower bounds, indicating the expression is dead code.
- Helper predicates of the form ``..MightOverflow..`` are provided for reasoning about overflow.

Simple range analysis: restrictions
===================================

The library only supports *constant* bounds.

e.g.

  .. code-block:: cpp

     if (x >= 1) {
        val[x]; // lowerBound(x) = 1
     }
     if (x >= y) {
        val[x]; // no lowerBound(x)
     }

In particular, we do not deduce that ``lowerBound(x) = y``. Integer values only!

Simple range analysis: notes
============================

- Often used to *exclude* known safe cases e.g. a fixed size array where the index upperBound is known.
- Ranges for variables modified in loops may be over approximated (see QL doc for details).
- ``lowerBound(expr)`` reports the bounds *before* conversion. For post conversion, try ``lowerBound(expr.getFullyConverted())``.

Guards
======

A *guard* is a condition which controls whether a certain part of the program is executed. For example:

  .. literalinclude:: ../query-examples/cpp/variant-analysis/guards/test.c
     :language: cpp

This is typically useful for determining whether a certain necessary check has occurred before a potentially unsafe operation.

Guards library
==============

QL comes with the ``Guards`` library, which can be used to determine which ``BasicBlocks`` are guarded by certain conditions. For example:

  .. literalinclude:: ../query-examples/cpp/variant-analysis/guards/GuardCondition.ql
     :language: ql

Would report the last two ``val[x]`` accesses from the previous slide.

Guards: API
===========

- ``GuardCondition`` represents an expression in the program that is a condition.
- The ``GuardCondition.controls(BasicBlock, boolean)`` predicate represents the set of basic blocks controlled by each guard
  condition, and includes whether they are controlled in the true case or false case.
