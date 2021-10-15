================================
Introduction to variant analysis
================================

CodeQL for C/C++

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/>`__
- `exiv2 database <http://downloads.lgtm.com/snapshots/cpp/exiv2/Exiv2_exiv2_b090f4d.zip>`__

.. note::

   For this example, we will be analyzing `exiv2 <https://github.com/Exiv2/exiv2>`__.

   You can also query the project in `the query console <https://lgtm.com/query/project:1506532406873/lang:cpp/>`__ on LGTM.com.

   .. insert database-note.rst to explain differences between database available to download and the version available in the query console.

   .. include:: ../slide-snippets/database-note.rst

   .. resume slides

.. Include language-agnostic section here

.. include:: ../slide-snippets/intro-ql-general.rst

Oops
====

.. code-block:: cpp
  :emphasize-lines: 3

  int write(int buf[], int size, int loc, int val) {
      if (loc >= size) {
         // return -1;
      }

      buf[loc] = val;

      return 0;
  }

- The return statement has been commented out (during debugging?)
- The if statement is now dead code
- No bounds checking!

.. note::

   Here’s a simple (artificial) bug, which we’ll develop a query to catch.

   This function writes a value to a given location in an array, first trying to do a bounds check to validate that the location is within bounds. However, the return statement has been commented out, leaving a redundant if statement and no bounds checking.

   This case can act as our “patient zero” in the variant analysis game.

A simple CodeQL query
=====================

.. literalinclude:: ../query-examples/cpp/empty-if-cpp.ql
   :language: ql

.. note::

   We are going to write a simple query which finds “if statements” with empty “then” blocks, so we can highlight the results like those on the previous slide. The query can be run in the `query console on LGTM <https://lgtm.com/query>`__, or in your `IDE <https://lgtm.com/help/lgtm/running-queries-ide>`__.

   A `query <https://codeql.github.com/docs/ql-language-reference/queries/>`__ consists of a “select” clause that indicates what results should be returned. Typically it will also provide a “from” clause to declare some variables, and a “where” clause to state conditions over those variables. For more information on the structure of query files (including links to useful topics in the `QL language reference <https://codeql.github.com/docs/ql-language-reference/>`__), see `About CodeQL queries <https://codeql.github.com/docs/writing-codeql-queries/about-codeql-queries/>`__.

   In our example here, the first line of the query imports the `CodeQL library for C/C++ <https://codeql.github.com/codeql-standard-libraries/cpp/>`__, which defines concepts like ``IfStmt`` and ``Block``.
   The query proper starts by declaring two variables–ifStmt and block. These variables represent sets of values in the database, according to the type of each of the variables. For example, ifStmt has the type IfStmt, which means it represents the set of all if statements in the program.

   If we simply selected these two variables::

     from IfStmt ifStmt, Block block
     select ifStmt, block

   We would get a result row for every combination of blocks and if statements in the program. This is known as a cross-product, because there is no logical condition linking the two variables. We can use the where clause to specify the condition that we are only interested in rows where the “block” is the “then” part of the if statement. We do this by specifying::

     block = ifStmt.getThen()

   This states that the block is equal to (not assigned!) the “then” part of the ``ifStmt``. ``getThen()`` is an operation which is available on any IfStmt. One way to interpret this is as a filtering operation – starting with every pair of block and if statements, check each one to whether the logical condition holds, and only keep the row if that is the case.
   We can add a second condition that specifies the block must be empty::

     and block.isEmpty()

   The ``isEmpty()`` operation is available on any Block, and is only true if the “block” has no children.

   Finally, we select a location, at which to report the problem, and a message, to explain what the problem is.



Structure of a query
====================

A **query file** has the extension ``.ql`` and contains a **query clause**, and optionally **predicates**, **classes**, and **modules**.

A **query library** has the extension ``.qll`` and does not contain a query clause, but may contain modules, classes, and predicates.

Each query library also implicitly defines a module.

**Import** statements allow the classes and predicates defined in one module to be used in another.

.. note::

  Queries are always contained in query files with the file extension ``.ql``.

  Parts of queries can be lifted into `library files <https://codeql.github.com/docs/ql-language-reference/modules/#library-modules>`__ with the extension ``.qll``. Definitions within such libraries can be brought into scope using ``import`` statements, and similarly QLL files can import each other’s definitions using “import” statements.

  Logic can be encapsulated as user-defined `predicates <https://codeql.github.com/docs/ql-language-reference/predicates/>`__ and `classes <https://codeql.github.com/docs/ql-language-reference/types/#classes>`__, and organized into `modules <https://codeql.github.com/docs/ql-language-reference/modules/>`__. Each QLL file implicitly defines a module, but QL and QLL files can also contain explicit module definitions, as we will see later.

Predicates
==========

A predicate allows you to pull out and name parts of a query.

.. container:: column-left

  .. literalinclude:: ../query-examples/cpp/empty-if-cpp.ql
     :language: ql
     :emphasize-lines: 6

.. container:: column-right

  .. literalinclude:: ../query-examples/cpp/empty-if-cpp-predicate.ql
     :language: ql
     :emphasize-lines: 3-5

.. note::

   A `predicate <https://codeql.github.com/docs/ql-language-reference/predicates/>`__ takes zero or more parameters, and its body is a condition on those parameters. The predicate may (or may not) hold. Predicates may also be `recursive <https://codeql.github.com/docs/ql-language-reference/predicates/#recursive-predicates>`__, simply by referring to themselves (directly or indirectly).

   You can imagine a predicate to be a self-contained from-where-select statement, that produces an intermediate relation, or table. In this case, the ``isEmpty`` predicate will be the set of all blocks which are empty.

Classes in QL
=============

A QL class allows you to name a set of values and define (member) predicates on them.

A class has at least one supertype and optionally a **characteristic predicate**; it contains the values that belong to *all* supertypes *and* satisfy the characteristic predicate, if provided.

Member predicates are inherited and can be overridden.

.. code-block:: ql

   class EmptyBlock extends Block {
     EmptyBlock() {
       this.getNumStmt() = 0
     }
   }

.. note::

  `Classes <https://codeql.github.com/docs/ql-language-reference/types/#classes>`__ model sets of values from the database. A class has one or more supertypes, and inherits `member predicates <https://codeql.github.com/docs/ql-language-reference/types/#member-predicates>`__ (methods) from each of them. Each value in a class must be in every supertype, but additional conditions can be stated in a so-called **characteristic predicate**, which looks a bit like a zero-argument constructor.

  In the example, declaring a variable “EmptyBlock e” will allow it to range over only those blocks that have zero statements.

Classes in QL continued
=======================

.. container:: column-left

  .. literalinclude:: ../query-examples/cpp/empty-if-cpp-predicate.ql
     :language: ql
     :emphasize-lines: 3-5

.. container:: column-right

  .. literalinclude:: ../query-examples/cpp/empty-if-cpp-class.ql
     :language: ql
     :emphasize-lines: 3-7


.. note::

   As shown in this example, classes behave much like unary predicates, but with ``instanceof`` instead of predicate calls to check membership. Later on, we will see how to define member predicates on classes.

Iterative query refinement
==========================

- **Common workflow**: Start with a simple query, inspect a few results, refine, repeat.

- For example, empty then branches are not a problem if there is an else.

- **Exercise**: How can we refine the query to take this into account?

**Hints**:

- Use member predicate ``IfStmt.getElse()``
- Use ``not exists(...)``

.. note::

   CodeQL makes it very easy to experiment with analysis ideas. A common workflow is to start with a simple query (like our “redundant if-statement” example), examine a few results, refine the query based on any patterns that emerge and repeat.

   As an exercise, refine the redundant-if query based on the observation that if the if-statement has an “else” clause, then even if the body of the “then” clause is empty, it’s not actually redundant.

Model answer: redundant if-statement
=====================================

.. literalinclude:: ../query-examples/cpp/empty-if-cpp-model.ql

.. note::

  You can explore the results generated when this query is run on exiv2 in LGTM `here <https://lgtm.com/query/4641433299746527262/>`__.
