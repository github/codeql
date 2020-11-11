.. _hash-consing-and-value-numbering:

Hash consing and value numbering
================================

You can use specialized CodeQL libraries to recognize expressions that are syntactically identical or compute the same value at runtime in C and C++ codebases.

About the hash consing and value numbering libraries
----------------------------------------------------

In C and C++ databases, each node in the abstract syntax tree is represented by a separate object. This allows both analysis and results display to refer to specific appearances of a piece of syntax. However, it is frequently useful to determine whether two expressions are equivalent, either syntactically or semantically.

The hash consing library (defined in ``semmle.code.cpp.valuenumbering.HashCons``) provides a mechanism for identifying expressions that have the same syntactic structure. The global value numbering library (defined in ``semmle.code.cpp.valuenumbering.GlobalValueNumbering``) provides a mechanism for identifying expressions that compute the same value at runtime. Both libraries partition the expressions in each function into equivalence classes represented by objects. Each ``HashCons`` object represents a set of expressions with identical parse trees, while ``GVN`` objects represent sets of expressions that will always compute the same value. For more information, see `Hash consing <https://en.wikipedia.org/wiki/Hash_consing>`__ and `Value numbering <https://en.wikipedia.org/wiki/Value_numbering>`__ on Wikipedia.

Example C code
--------------

In the following C program, ``x + y`` and ``x + z`` will be assigned the same value number but different hash conses.

.. code-block:: c

    int x = 1;
    int y = 2;
    int z = y;
    if(x + y == x + z) {
      ...
    }

However, in the next example, the uses of ``x + y`` will have different value numbers but the same hash cons.

.. code-block:: c

    int x = 1;
    int y = 2;
    if(x + y) {
      ...
    }

    x = 2;

    if(x + y) {
      ...
    }

Value numbering
---------------

The value numbering library (defined in ``semmle.code.cpp.valuenumbering.GlobalValueNumbering``) provides a mechanism for identifying expressions that compute the same value at runtime. Value numbering is useful when your primary concern is with the values being produced or the eventual machine code being run. For instance, value numbering might be used to determine whether a check is being done against the same value as the operation it is guarding.

The value numbering API
~~~~~~~~~~~~~~~~~~~~~~~

The value numbering library exposes its interface primarily through the ``GVN`` class. Each instance of ``GVN`` represents a set of expressions that will always evaluate to the same value. To get an expression in the set represented by a particular ``GVN``, use the ``getAnExpr()`` member predicate.

To get the ``GVN`` of an ``Expr``, use the ``globalValueNumber`` predicate.

.. note::

    While the ``GVN`` class has ``toString`` and ``getLocation`` methods, these are only provided as debugging aids. They give the ``toString`` and ``getLocation`` of an arbitrary ``Expr`` within the set.

Why not a predicate?
~~~~~~~~~~~~~~~~~~~~

The obvious interface for this library would be a predicate ``equivalent(Expr e1, Expr e2)``. However, this predicate would be very large, with a quadratic number of rows for each set of equivalent expressions. By using a class as an intermediate step, the number of rows can be kept linear, and therefore can be cached.

Example query
~~~~~~~~~~~~~

This query uses the ``GVN`` class to identify calls to ``strncpy`` where the size argument is derived from the source rather than the destination

.. code-block:: ql

    from FunctionCall strncpy, FunctionCall strlen
    where
      strncpy.getTarget().hasGlobalName("strncpy") and
      strlen.getTarget().hasGlobalName("strlen") and
      globalValueNumber(strncpy.getArgument(1)) = globalValueNumber(strlen.getArgument(0)) and
      strlen = strncpy.getArgument(2)
    select ci, "This call to strncpy is bounded by the size of the source rather than the destination"

.. TODO: a second example

Hash consing
------------

The hash consing library (defined in ``semmle.code.cpp.valuenumbering.HashCons``) provides a mechanism for identifying expressions that have the same syntactic structure. Hash consing is useful when your primary concern is with the text of the code. For instance, hash consing might be used to detect duplicate code within a function.

The hash consing API
~~~~~~~~~~~~~~~~~~~~

The hash consing library exposes its interface primarily through the ``HashCons`` class. Each instance of ``HashCons`` represents a set of expressions within one function that have the same syntax (including referring to the same variables). To get an expression in the set represented by a particular ``HashCons``, use the ``getAnExpr()`` member predicate.

.. note::

    While the ``HashCons`` class has ``toString`` and ``getLocation`` methods, these are only provided as debugging aids. They give the ``toString`` and ``getLocation`` of an arbitrary ``Expr`` within the set.

To get the ``HashCons`` of an ``Expr``, use the ``hashCons`` predicate.

Example query
~~~~~~~~~~~~~

.. TODO: prose explanations

.. code-block:: ql

    import cpp
    import semmle.code.cpp.valuenumbering.HashCons

    from IfStmt outer, IfStmt inner
    where
      outer.getElse+() = inner and
      hashCons(outer.getCondition()) = hashCons(inner.getCondition())
    select inner.getCondition(), "The condition of this if statement duplicates the condition of $@",
      outer.getCondition(), "an enclosing if statement"

Further reading
---------------

.. include:: ../../reusables/cpp-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst