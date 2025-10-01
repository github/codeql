.. _basic-query-for-rust-code:

Basic query for Rust code
==========================

Learn to write and run a simple CodeQL query using Visual Studio Code with the CodeQL extension.

.. include:: ../reusables/vs-code-basic-instructions/setup-to-run-queries.rst

About the query
---------------

The query we're going to run performs a basic search of the code for ``if`` expressions that are redundant, in the sense that they have an empty ``then`` branch. For example, code such as:

.. code-block:: rust

   if error {
     // we should handle the error
   }

.. include:: ../reusables/vs-code-basic-instructions/find-database.rst

Running a quick query
---------------------

.. include:: ../reusables/vs-code-basic-instructions/run-quick-query-1.rst

#. In the quick query tab, delete the content and paste in the following query.

   .. code-block:: ql

      import rust

      from IfExpr ifExpr
      where ifExpr.getThen().(BlockExpr).getStmtList().getNumberOfStmtOrExpr() = 0
      select ifExpr, "This 'if' expression is redundant."

.. include:: ../reusables/vs-code-basic-instructions/run-quick-query-2.rst

.. image:: ../images/codeql-for-visual-studio-code/basic-rust-query-results-1.png
   :align: center

If any matching code is found, click a link in the ``ifExpr`` column to open the file and highlight the matching ``if`` expression.

.. image:: ../images/codeql-for-visual-studio-code/basic-rust-query-results-2.png
   :align: center

.. include:: ../reusables/vs-code-basic-instructions/note-store-quick-query.rst

About the query structure
~~~~~~~~~~~~~~~~~~~~~~~~~

After the initial ``import`` statement, this simple query comprises three parts that serve similar purposes to the FROM, WHERE, and SELECT parts of an SQL query.

+----------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
| Query part                                                                       | Purpose                                                                                                           | Details                                                                                              |
+==================================================================================+===================================================================================================================+======================================================================================================+
| ``import rust``                                                                  | Imports the standard CodeQL AST libraries for Rust.                                                               | Every query begins with one or more ``import`` statements.                                           |
+----------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
| ``from IfExpr ifExpr``                                                           | Defines the variables for the query.                                                                              | We use: an ``IfExpr`` variable for ``if`` expressions.                                               |
|                                                                                  | Declarations are of the form:                                                                                     |                                                                                                      |
|                                                                                  | ``<type> <variable name>``                                                                                        |                                                                                                      |
+----------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
| ``where ifExpr.getThen().(BlockExpr).getStmtList().getNumberOfStmtOrExpr() = 0`` | Defines a condition on the variables.                                                                             | ``ifExpr.getThen()``: gets the ``then`` branch of the ``if`` expression.                             |
|                                                                                  |                                                                                                                   | ``.(BlockExpr)``: requires that the ``then`` branch is a block expression (``{ }``).                 |
|                                                                                  |                                                                                                                   | ``.getStmtList()``: gets the list of things in the block.                                            |
|                                                                                  |                                                                                                                   | ``.getNumberOfStmtOrExpr() = 0``: requires that there are no statements or expressions in the block. |
+----------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+
| ``select ifExpr, "This 'if' expression is redundant."``                          | Defines what to report for each match.                                                                            | Reports the resulting ``if`` expression with a string that explains the problem.                     |
|                                                                                  |                                                                                                                   |                                                                                                      |
|                                                                                  | ``select`` statements for queries that are used to find instances of poor coding practice are always in the form: |                                                                                                      |
|                                                                                  | ``select <program element>, "<alert message>"``                                                                   |                                                                                                      |
+----------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------+

Extend the query
----------------

Query writing is an inherently iterative process. You write a simple query and then, when you run it, you discover examples that you had not previously considered, or opportunities for improvement.

Remove false positive results
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Browsing the results of our basic query shows that it could be improved. Among the results you are likely to find examples of ``if`` expressions with an ``else`` branch, where an empty ``then`` branch does serve a purpose. For example:

.. code-block:: rust

   if (option == "-verbose") {
     // nothing to do - handled earlier
   } else {
     handleError("unrecognized option")
   }

In this case, identifying the ``if`` expression with the empty ``then`` branch as redundant is a false positive. One solution to this is to modify the query to select ``if`` expressions where both the ``then`` and ``else`` branches are missing.

To exclude ``if`` expressions that have an ``else`` branch:

#. Add the following to the where clause:

   .. code-block:: ql

      and not exists(ifExpr.getElse())

   The ``where`` clause is now:

   .. code-block:: ql

      where
        ifExpr.getThen().(BlockExpr).getStmtList().getNumberOfStmtOrExpr() = 0 and
        not exists(ifExpr.getElse())

#. Re-run the query.

   There are now fewer results because ``if`` expressions with an ``else`` branch are no longer included.

Further reading
---------------

.. include:: ../reusables/rust-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst

.. Article-specific substitutions for the reusables used in docs/codeql/reusables/vs-code-basic-instructions

.. |language-text| replace:: Rust

.. |language-code| replace:: ``rust``

.. |example-url| replace:: https://github.com/rust-lang/rustlings

.. |image-quick-query| image:: ../images/codeql-for-visual-studio-code/quick-query-tab-rust.png

.. |result-col-1|  replace:: The first column corresponds to the expression ``ifExpr`` and is linked to the location in the source code of the project where ``ifExpr`` occurs.
