Basic query for Java code
=========================

Learn to write and run a simple CodeQL query using LGTM.

About the query
---------------

The query we're going to run performs a basic search of the code for ``if`` statements that are redundant, in the sense that they have an empty then branch. For example, code such as:

.. code-block:: java

   if (error) { }

Running the query
-----------------

#. In the main search box on LGTM.com, search for the project you want to query. For tips, see `Searching <https://lgtm.com/help/lgtm/searching>`__.

#. Click the project in the search results.

#. Click **Query this project**.

   This opens the query console. (For information about using this, see `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.)

   .. pull-quote::

      Note

      Alternatively, you can go straight to the query console by clicking **Query console** (at the top of any page), selecting **Java** from the **Language** drop-down list, then choosing one or more projects to query from those displayed in the **Project** drop-down list.

#. Copy the following query into the text box in the query console:

   .. code-block:: ql

      import java

      from IfStmt ifstmt, Block block
      where ifstmt.getThen() = block and
        block.getNumStmt() = 0
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

   ➤ `Example query results <https://lgtm.com/query/3235645104630320782/>`__

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
| ``import java``                                               | Imports the standard CodeQL libraries for Java.                                                                   | Every query begins with one or more ``import`` statements.                                                             |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``from IfStmt ifstmt, Block block``                           | Defines the variables for the query.                                                                              | We use:                                                                                                                |
|                                                               | Declarations are of the form:                                                                                     |                                                                                                                        |
|                                                               | ``<type> <variable name>``                                                                                        | - an ``IfStmt`` variable for ``if`` statements                                                                         |
|                                                               |                                                                                                                   | - a ``Block`` variable for the then block                                                                              |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+
| ``where ifstmt.getThen() = block and block.getNumStmt() = 0`` | Defines a condition on the variables.                                                                             | ``ifstmt.getThen() = block`` relates the two variables. The block must be the ``then`` branch of the ``if`` statement. |
|                                                               |                                                                                                                   |                                                                                                                        |
|                                                               |                                                                                                                   | ``block.getNumStmt() = 0`` states that the block must be empty (that is, it contains no statements).                   |
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

Browsing the results of our basic query shows that it could be improved. Among the results you are likely to find examples of ``if`` statements with an ``else`` branch, where an empty ``then`` branch does serve a purpose. For example:

.. code-block:: java

   if (...) {
     ...
   } else if ("-verbose".equals(option)) {
     // nothing to do - handled earlier
   } else {
     error("unrecognized option");
   }

In this case, identifying the ``if`` statement with the empty ``then`` branch as redundant is a false positive. One solution to this is to modify the query to ignore empty ``then`` branches if the ``if`` statement has an ``else`` branch.

To exclude ``if`` statements that have an ``else`` branch:

#. Extend the where clause to include the following extra condition:

   .. code-block:: ql

      and not exists(ifstmt.getElse())

   The ``where`` clause is now:

   .. code-block:: ql

      where ifstmt.getThen() = block and
        block.getNumStmt() = 0 and
        not exists(ifstmt.getElse())

#. Click **Run**.

   There are now fewer results because ``if`` statements with an ``else`` branch are no longer included.

➤ `See this in the query console <https://lgtm.com/query/6382189874776576029/>`__

Further reading
---------------

.. include:: ../../reusables/java-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
