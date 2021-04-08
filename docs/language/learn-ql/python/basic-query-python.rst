Basic query for Python code
===========================

Learn to write and run a simple CodeQL query using LGTM.

About the query
---------------

The query we're going to run performs a basic search of the code for ``if`` statements that are redundant, in the sense that they only include a ``pass`` statement. For example, code such as:

.. code-block:: python

   if error: pass

Running the query
-----------------

#. In the main search box on LGTM.com, search for the project you want to query. For tips, see `Searching <https://lgtm.com/help/lgtm/searching>`__.

#. Click the project in the search results.

#. Click **Query this project**.

   This opens the query console. (For information about using this, see `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.)

   .. pull-quote::

      Note

      Alternatively, you can go straight to the query console by clicking **Query console** (at the top of any page), selecting **Python** from the **Language** drop-down list, then choosing one or more projects to query from those displayed in the **Project** drop-down list.

#. Copy the following query into the text box in the query console:

   .. code-block:: ql

      import python

      from If ifstmt, Stmt pass
      where pass = ifstmt.getStmt(0) and
        pass instanceof Pass
      select ifstmt, "This 'if' statement is redundant."

   LGTM checks whether your query compiles and, if all is well, the **Run** button changes to green to indicate that you can go ahead and run the query.

#. Click **Run**.

   The name of the project you are querying, and the ID of the most recently analyzed commit to the project, are listed below the query box. To the right of this is an icon that indicates the progress of the query operation:

   .. image:: ../../images/query-progress.png
       :align: center

   .. pull-quote::

      Note

      Your query is always run against the most recently analyzed commit to the selected project.

   The query will take a few moments to return results. When the query completes, the results are displayed below the project name. The query results are listed in two columns, corresponding to the two expressions in the ``select`` clause of the query. The first column corresponds to the expression ``ifstmt`` and is linked to the location in the source code of the project where ``ifstmt`` occurs. The second column is the alert message.

   ➤ `Example query results <https://lgtm.com/query/3592297537117272922/>`__

   .. pull-quote::

      Note

      An ellipsis (…) at the bottom of the table indicates that the entire list is not displayed—click it to show more results.

#. If any matching code is found, click a link in the ``ifstmt`` column to view the ``if`` statement in the code viewer.

   The matching ``if`` statement is highlighted with a yellow background in the code viewer. If any code in the file also matches a query from the standard query library for that language, you will see a red alert message at the appropriate point within the code.

About the query structure
~~~~~~~~~~~~~~~~~~~~~~~~~

After the initial ``import`` statement, this simple query comprises three parts that serve similar purposes to the FROM, WHERE, and SELECT parts of an SQL query.

+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| Query part                                                    | Purpose                                                                                                           | Details                                                                                                                |
+===============================================================+===================================================================================================================+========================================================================================================================+
| ``import python``                                             | Imports the standard CodeQL libraries for Python.                                                                 | Every query begins with one or more ``import`` statements.                                                             |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``from If ifstmt, Stmt pass``                                 | Defines the variables for the query.                                                                              | We use:                                                                                                                |
|                                                               | Declarations are of the form:                                                                                     |                                                                                                                        |
|                                                               | ``<type> <variable name>``                                                                                        | - an ``If`` variable for ``if`` statements                                                                             |
|                                                               |                                                                                                                   | - a ``Stmt`` variable for the statement                                                                                |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``where pass = ifstmt.getStmt(0) and pass instanceof Pass``   | Defines a condition on the variables.                                                                             | ``pass = ifstmt.getStmt(0)``: ``pass`` is the first statement in the ``if`` statement.                                 |
|                                                               |                                                                                                                   |                                                                                                                        |
|                                                               |                                                                                                                   | ``pass instanceof Pass``: ``pass`` must be a pass statement.                                                           |
|                                                               |                                                                                                                   |                                                                                                                        |
|                                                               |                                                                                                                   | In other words, the first statement contained in the ``if`` statement is a ``pass`` statement.                         |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``select ifstmt, "This 'if' statement is redundant."``        | Defines what to report for each match.                                                                            | Reports the resulting ``if`` statement with a string that explains the problem.                                        |
|                                                               |                                                                                                                   |                                                                                                                        |
|                                                               | ``select`` statements for queries that are used to find instances of poor coding practice are always in the form: |                                                                                                                        |
|                                                               | ``select <program element>, "<alert message>"``                                                                   |                                                                                                                        |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+

Extend the query
----------------

Query writing is an inherently iterative process. You write a simple query and then, when you run it, you discover examples that you had not previously considered, or opportunities for improvement.

Remove false positive results
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Browsing the results of our basic query shows that it could be improved. Among the results you are likely to find examples of ``if`` statements with an ``else`` branch, where a ``pass`` statement does serve a purpose. For example:

.. code-block:: python

   if cond():
     pass
   else:
     do_something()

In this case, identifying the ``if`` statement with the ``pass`` statement as redundant is a false positive. One solution to this is to modify the query to ignore ``pass`` statements if the ``if`` statement has an ``else`` branch.

To exclude ``if`` statements that have an ``else`` branch:

#. Extend the ``where`` clause to include the following extra condition:

   .. code-block:: ql

      and not exists(ifstmt.getOrelse())

   The ``where`` clause is now:

   .. code-block:: ql

      where pass = ifstmt.getStmt(0) and
        pass instanceof Pass and
        not exists(ifstmt.getOrelse())

#. Click **Run**.

   There are now fewer results because ``if`` statements with an ``else`` branch are no longer included.

➤ `See this in the query console <https://lgtm.com/query/3424727946018612474/>`__

Further reading
---------------

.. include:: ../../reusables/python-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
