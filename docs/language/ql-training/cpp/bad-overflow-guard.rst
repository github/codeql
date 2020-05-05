===========================
Example: Bad overflow guard
===========================

CodeQL for C/C++

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html>`__
- `ChakraCore database <https://downloads.lgtm.com/snapshots/cpp/microsoft/chakracore/ChakraCore-revision-2017-April-12--18-13-26.zip>`__

.. note::

   For the examples in this presentation, we will be analyzing `ChakraCore <https://github.com/microsoft/ChakraCore>`__.

   You can query the project in `the query console <https://lgtm.com/query/project:2034240708/lang:cpp/>`__ on LGTM.com.

   .. insert database-note.rst to explain differences between database available to download and the version available in the query console.

   .. include:: ../slide-snippets/database-note.rst

   .. resume slides

Checking for overflow in C
==========================

- Arithmetic operations overflow if the result is too large for their type.
- Developers sometimes exploit this to write overflow checks:

   .. code-block:: cpp

      if (v + b < v) {
          handle_error("overflow");
      } else {
          result = v + b;
      }
    
   Where might this go wrong?

.. note::

  - In C/C++ we often need to check for whether an operation `overflows <https://en.wikipedia.org/wiki/Integer_overflow>`__.
  - An overflow is when an arithmetic operation, such as an addition, results in a number which is too large to be stored in the type.
  - When an operation overflows, the value “wraps” around.
  - A typical way to check for overflow of an addition, therefore, is whether the result is less than one of the arguments–that is the result has **wrapped**.

Integer promotion
=================

From `https://en.cppreference.com/w/c/language/conversion <https://en.cppreference.com/w/c/language/conversion>`__:

.. rst-class:: quote

  Integer promotion is the implicit conversion of a value of any integer type with rank less or equal to rank of ``int`` ... to the value of type ``int`` or ``unsigned int``.

- The arguments of the following arithmetic operators undergo implicit conversions:

  - binary arithmetic ``* / % + -``
  - relational operators ``< > <= >= == !=``
  - binary bitwise operators ``& ^ |``
  - the conditional operator ``?:``

.. note::

  - Most of the time integer conversion works fine. However, the rules governing addition in C/C++ are complex, and it's easy to get bitten.
  - CPUs generally prefer to perform arithmetic operations on 32-bit or larger integers, as the architectures are optimized to perform those efficiently.
  - The compiler therefore performs “integer promotion” for arguments to arithmetic operations that are smaller than 32-bit.

Checking for overflow in C revisited
====================================

Which branch gets executed in this example? What is the value of ``result``?

   .. code-block:: cpp
   
     uint16_t v = 65535;
     uint16_t b = 1;
     uint16_t result;
     if (v + b < v) {
         handle_error("overflow");
     } else {
         result = v + b;
     }
   
.. note::

  In this example the second branch is executed, even though there is a 16-bit overflow, and ``result`` is set to zero.

Checking for overflow in C revisited
====================================

Here is the example again, with the conversions made explicit:

   .. code-block:: cpp
     :emphasize-lines: 4,7
   
     uint16_t v = 65535;
     uint16_t b = 1;
     uint16_t result;
     if ((int)v + (int)b < (int)v) {
         handle_error("overflow");
     } else {
         result = (uint16_t)((int)v + (int)b);
     }
   
.. note::

  In this example the second branch is executed, even though there is a 16-bit overflow, and result is set to zero.

  Explanation:

  - The two integer arguments to the addition, ``v`` and ``b``, are promoted to 32-bit integers.
  - The comparison (``<``) is also an arithmetic operation, therefore it will also be completed on 32-bit integers.
  - This means that ``v + b < v`` will never be true, because v and b can hold at most 2 :sup:`16`.
  - Therefore, the second branch is executed, but the result of the addition is stored into the result variable. Overflow will still occur as result is a 16-bit integer.

This happens even though the overflow check passed!

.. rst-class:: background2

Developing a CodeQL query
=========================

Finding bad overflow guards

CodeQL query: bad overflow guards
==================================

Let’s look for overflow guards of the form ``v + b < v``, using the classes
``AddExpr``, ``Variable`` and ``RelationalOperation`` from the ``cpp`` library.

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/bad-overflow-guard-1.ql
   :language: ql

.. note::

  - When performing variant analysis, it is usually helpful to write a simple query that finds the simple syntactic pattern, before trying to go on to describe the cases where it goes wrong.
  - In this case, we start by looking for all the *overflow* checks, before trying to refine the query to find all *bad overflow* checks.
  - The ``select`` clause defines what this query is looking for:

    - an ``AddExpr``: the expression that is being checked for overflow.
    - a ``RelationalOperation``: the overflow comparison check.
    - a ``Variable``: used as an argument to both the addition and comparison.

  - The ``where`` part of the query ties these three variables together using `predicates <https://help.semmle.com/QL/ql-handbook/predicates.html>`__ defined in the `standard CodeQL for C/C++ library <https://help.semmle.com/qldoc/cpp/>`__.

CodeQL query: bad overflow guards
=================================

We want to ensure the operands being added have size less than 4 bytes.

We may want to reuse this logic, so let us create a separate predicate.

Looking at autocomplete suggestions, we see that we can get the type of an expression using the ``getType()`` method.

We can get the size (in bytes) of a type using the ``getSize()`` method.

.. rst-class:: build

.. code-block:: ql

  predicate isSmall(Expr e) {
    e.getType().getSize() < 4
  }

.. note::

  - An important part of the query is to determine whether a given expression has a “small” type that is going to trigger integer promotion.
  - We therefore write a helper predicate for small expressions.
  - This predicate effectively represents the set of all expressions in the database where the size of the type of the expression is less than 4 bytes, that is, less than 32-bits.

CodeQL query: bad overflow guards
==================================

We can ensure the operands being added have size less than 4 bytes, using our new predicate.

QL has logical quantifiers like ``exists`` and ``forall``, allowing us to declare variables and enforce a certain condition on them.

Now our query becomes:

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/bad-overflow-guard-2.ql
   :language: ql

.. note::

  - Recall from earlier that what makes an overflow check a “bad” check is that all the arguments to the addition are integers smaller than 32-bits.
  - We could write this by using our helper predicate ``isSmall`` to specify that each individual operand to the addition ``isSmall`` (that is under 32-bits):

    .. code-block:: ql
  
      isSmall(a.getLeftOperand()) and
      isSmall(a.getRightOperand())

  - However, this is a little bit repetitive. What we really want to say is that: all the operands of the addition are small. Fortunately, QL provides a ``forall`` formula that we can use in these circumstances.
  - A ``forall`` has three parts:

    - A “declaration” part, where we can introduce variables.
    - A “range” part, which allows us to restrict those variables.
    - A “condition” part. The ``forall`` as a whole holds if the condition holds for each of the values in the range.
  - In our case:

    - The declaration introduces a variable for expressions, called ``op``. At this stage, this variable represents all the expressions in the program.
    - The “range” part, ``op = a.getAnOperand()``,  restricts ``op`` to being one of the two operands to the addition.
    - The “condition” part, ``isSmall(op)``, says that the ``forall`` holds only if the condition (that the ``op`` is small) holds for everything in the range–that is, both the arguments to the addition.

CodeQL query: bad overflow guards
=================================

Sometimes the result of the addition is cast to a small type of size less than 4 bytes, preventing automatic widening. We don’t want our query to flag these instances.

We can use predicate ``Expr.getExplicitlyConverted()`` to reason about casts that are applied to an expression, adding  this restriction to our query:

.. code-block:: ql

   not isSmall(a.getExplicitlyConverted())

The final query
===============

.. literalinclude:: ../query-examples/cpp/bad-overflow-guard-3.ql
   :language: ql

This query finds a single result in our historic database, which was `a genuine bug in ChakraCore <https://github.com/Microsoft/ChakraCore/commit/2500e1cdc12cb35af73d5c8c9b85656aba6bab4d>`__.
