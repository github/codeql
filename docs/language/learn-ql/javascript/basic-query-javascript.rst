Basic query for JavaScript code
===============================

Learn to write and run a simple CodeQL query using LGTM.

About the query
---------------

In JavaScript, any expression can be turned into an expression statement. While this is sometimes convenient, it can be dangerous. For example, imagine a programmer wants to assign a new value to a variable ``x`` by means of an assignment ``x = 42``. However, they accidentally type two equals signs, producing the comparison statement ``x == 42``. This is valid JavaScript, so no error is generated. The statement simply compares ``x`` to ``42``, and then discards the result of the comparison.

The query you will run finds instances of this problem. The query searches for expressions ``e`` that are pure—that is, their evaluation does not lead to any side effects—but appear as an expression statement.

Running the query
-----------------

#. In the main search box on LGTM.com, search for the project you want to query. For tips, see `Searching <https://lgtm.com/help/lgtm/searching>`__.

#. Click the project in the search results.

#. Click **Query this project**.

   This opens the query console. (For information about using this, see `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.)

   .. pull-quote::

      Note

      Alternatively, you can go straight to the query console by clicking **Query console** (at the top of any page), selecting **JavaScript** from the **Language** drop-down list, then choosing one or more projects to query from those displayed in the **Project** drop-down list.

#. Copy the following query into the text box in the query console:

   .. code-block:: ql

      import javascript

      from Expr e
      where e.isPure() and
        e.getParent() instanceof ExprStmt
      select e, "This expression has no effect."

   LGTM checks whether your query compiles and, if all is well, the **Run** button changes to green to indicate that you can go ahead and run the query.

#. Click **Run**.

   The name of the project you are querying, and the ID of the most recently analyzed commit to the project, are listed below the query box. To the right of this is an icon that indicates the progress of the query operation:

   .. image:: ../../images/query-progress.png
       :align: center

   .. pull-quote::

      Note

      Your query is always run against the most recently analyzed commit to the selected project.

   The query will take a few moments to return results. When the query completes, the results are displayed below the project name. The query results are listed in two columns, corresponding to the two expressions in the ``select`` clause of the query. The first column corresponds to the expression ``e`` and is linked to the location in the source code of the project where ``e`` occurs. The second column is the alert message.

   ➤ `Example query results <https://lgtm.com/query/5137013631828816943/>`__

   .. pull-quote::

      Note

      An ellipsis (…) at the bottom of the table indicates that the entire list is not displayed—click it to show more results.

#. If any matching code is found, click one of the links in the ``e`` column to view the expression in the code viewer.

   The matching statement is highlighted with a yellow background in the code viewer. If any code in the file also matches a query from the standard query library for that language, you will see a red alert message at the appropriate point within the code.

About the query structure
~~~~~~~~~~~~~~~~~~~~~~~~~

After the initial ``import`` statement, this simple query comprises three parts that serve similar purposes to the FROM, WHERE, and SELECT parts of an SQL query.

+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| Query part                                                    | Purpose                                                                                                           | Details                                                                                                                |
+===============================================================+===================================================================================================================+========================================================================================================================+
| ``import javascript``                                         | Imports the standard CodeQL libraries for JavaScript.                                                             | Every query begins with one or more ``import`` statements.                                                             |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``from Expr e``                                               | Defines the variables for the query.                                                                              | ``e`` is declared as a variable that ranges over expressions.                                                          |
|                                                               | Declarations are of the form:                                                                                     |                                                                                                                        |
|                                                               | ``<type> <variable name>``                                                                                        |                                                                                                                        |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``where e.isPure() and e.getParent() instanceof ExprStmt``    | Defines a condition on the variables.                                                                             | ``e.isPure()``: The expression is side-effect-free.                                                                    |
|                                                               |                                                                                                                   |                                                                                                                        |
|                                                               |                                                                                                                   | ``e.getParent() instanceof ExprStmt``: The parent of the expression is an expression statement.                        |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``select e, "This expression has no effect."``                | Defines what to report for each match.                                                                            | Report the expression with a string that explains the problem.                                                         |
|                                                               |                                                                                                                   |                                                                                                                        |
|                                                               | ``select`` statements for queries that are used to find instances of poor coding practice are always in the form: |                                                                                                                        |
|                                                               | ``select <program element>, "<alert message>"``                                                                   |                                                                                                                        |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+

Extend the query
----------------

Query writing is an inherently iterative process. You write a simple query and then, when you run it, you discover examples that you had not previously considered, or opportunities for improvement.

Remove false positive results
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Browsing the results of our basic query shows that it could be improved. Among the results you are likely to find ``use strict`` directives. These are interpreted specially by modern browsers with strict mode support and so these expressions *do* have an effect.

To remove directives from the results:

#. Extend the ``where`` clause to include the following extra condition:

   .. code-block:: ql

      and not e.getParent() instanceof Directive

   The ``where`` clause is now:

   .. code-block:: ql

      where e.isPure() and
        e.getParent() instanceof ExprStmt and 
        not e.getParent() instanceof Directive

#. Click **Run**.

   There are now fewer results as ``use strict`` directives are no longer reported.

The improved query finds several results on the example project including `this result <https://lgtm.com/projects/g/ajaxorg/ace/rev/ad50673d7137c09d1a5a6f0ef83633a149f9e3d1/files/lib/ace/keyboard/vim.js#L320>`__:

.. code-block:: javascript

   point.bias == -1;

As written, this statement compares ``point.bias`` against ``-1`` and then discards the result. Most likely, it was instead meant to be an assignment ``point.bias = -1``.

Further reading
---------------

.. include:: ../../reusables/javascript-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
