.. _basic-query-for-go-code:

Basic query for Go code
=======================

Learn to write and run a simple CodeQL query using LGTM.

About the query
---------------

The query we're going to run searches the code for methods defined on value types that modify their receiver by writing a field:

.. code-block:: go

   func (s MyStruct) valueMethod() { s.f = 1 } // method on value

This is problematic because the receiver argument is passed by value, not by reference. Consequently, valueMethod is called with a copy of the receiver object, so any changes it makes to the receiver will be invisible to the caller. To prevent this, the method should be defined on a pointer instead:

.. code-block:: go

   func (s *MyStruct) pointerMethod() { s.f = 1 } // method on pointer

For further information on using methods on values or pointers in Go, see the `Go FAQ <https://golang.org/doc/faq#methods_on_values_or_pointers>`__.

Running the query
-----------------

#. In the main search box on LGTM.com, search for the project you want to query. For tips, see `Searching <https://lgtm.com/help/lgtm/searching>`__.

#. Click the project in the search results.

#. Click **Query this project**.

   This opens the query console. (For information about using this, see `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.)

   .. pull-quote::

      Note

      Alternatively, you can go straight to the query console by clicking **Query console** (at the top of any page), selecting **Go** from the **Language** drop-down list, then choosing one or more projects to query from those displayed in the **Project** drop-down list.

#. Copy the following query into the text box in the query console:

   .. code-block:: ql

      import go

      from Method m, Variable recv, Write w, Field f
      where
        recv = m.getReceiver() and
        w.writesField(recv.getARead(), f, _) and
        not recv.getType() instanceof PointerType
      select w, "This update to " + f + " has no effect, because " + recv + " is not a pointer."

   LGTM checks whether your query compiles and, if all is well, the **Run** button changes to green to indicate that you can go ahead and run the query.

#. Click **Run**.

   The name of the project you are querying, and the ID of the most recently analyzed commit to the project, are listed below the query box. To the right of this is an icon that indicates the progress of the query operation:

   .. image:: ../images/query-progress.png
       :align: center

   .. pull-quote::

      Note

      Your query is always run against the most recently analyzed commit to the selected project.

   The query will take a few moments to return results. When the query completes, the results are displayed below the project name. The query results are listed in two columns, corresponding to the two expressions in the ``select`` clause of the query. The first column corresponds to ``w``, which is the location in the source code where the receiver ``recv`` is modified. The second column is the alert message.

   ➤ `Example query results <https://lgtm.com/query/6221190009056970603/>`__

   .. pull-quote::

      Note

      An ellipsis (…) at the bottom of the table indicates that the entire list is not displayed—click it to show more results.

#. If any matching code is found, click a link in the ``w`` column to view it in the code viewer.

   The matching ``w`` is highlighted with a yellow background in the code viewer. If any code in the file also matches a query from the standard query library for that language, you will see a red alert message at the appropriate point within the code.

About the query structure
~~~~~~~~~~~~~~~~~~~~~~~~~

After the initial ``import`` statement, this simple query comprises three parts that serve similar purposes to the FROM, WHERE, and SELECT parts of an SQL query.

+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------+
| Query part                                                    | Purpose                                                                                                           | Details                                                                                                                              |
+===============================================================+===================================================================================================================+======================================================================================================================================+
| ``import go``                                                 | Imports the standard CodeQL libraries for Go.                                                                     | Every query begins with one or more ``import`` statements.                                                                           |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``from Method m, Variable recv, Write w, Field f``            | Defines the variables for the query.                                                                              | We declare:                                                                                                                          |
|                                                               | Declarations are of the form:                                                                                     |                                                                                                                                      |
|                                                               | ``<type> <variable name>``                                                                                        | - ``m`` as a variable for all methods                                                                                                |
|                                                               |                                                                                                                   | - a ``recv`` variable, which is the receiver of ``m``                                                                                |
|                                                               |                                                                                                                   | - ``w`` as the location in the code where the receiver is modified                                                                   |
|                                                               |                                                                                                                   | - ``f`` as the field that is written when ``m`` is called                                                                            |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``where recv = m.getReceiver() and                            | Defines a condition on the variables.                                                                             | ``recv = m.getReceiver()`` states that ``recv`` must be the receiver variable of ``m``.                                              |
| w.writesField(recv.getARead(), f, _) and                      |                                                                                                                   |                                                                                                                                      |
| not recv.getType() instanceof PointerType``                   |                                                                                                                   | ``w.writesField(recv.getARead(), f, _)`` states that ``w`` must be a location in the code where field ``f`` of ``recv`` is modified. |
|                                                               |                                                                                                                   | We use a :ref:`'don't-care' expression <don-t-care-expressions>` ``_``                                                               |
|                                                               |                                                                                                                   | for the value that is written to ``f``—the actual value doesn't matter in this query.                                                |
|                                                               |                                                                                                                   |                                                                                                                                      |
|                                                               |                                                                                                                   | ``not recv.getType() instanceof PointerType`` states that ``m`` is not a pointer method.                                             |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------+
| ``select w, "This update to " + f +                           | Defines what to report for each match.                                                                            | Reports ``w`` with a message that explains the potential problem.                                                                    |
| " has no effect, because " + recv + " is not a pointer."``    |                                                                                                                   |                                                                                                                                      |
|                                                               | ``select`` statements for queries that are used to find instances of poor coding practice are always in the form: |                                                                                                                                      |
|                                                               | ``select <program element>, "<alert message>"``                                                                   |                                                                                                                                      |
+---------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------+

Extend the query
----------------

Query writing is an inherently iterative process. You write a simple query and then, when you run it, you discover examples that you had not previously considered, or opportunities for improvement.

Remove false positive results
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Among the results generated by the first iteration of this query, you can find cases where a value method is called but the receiver variable is returned. In such cases, the change to the receiver is not invisible to the caller, so a pointer method is not required. These are false positive results and you can improve the query by adding an extra condition to remove them.

To exclude these values:

#. Extend the where clause to include the following extra condition:

   .. code-block:: ql

      not exists(ReturnStmt ret | ret.getExpr() = recv.getARead().asExpr())

   The ``where`` clause is now:

   .. code-block:: ql

      where e.isPure() and
        recv = m.getReceiver() and
        w.writesField(recv.getARead(), f, _) and
        not recv.getType() instanceof PointerType and
        not exists(ReturnStmt ret | ret.getExpr() = recv.getARead().asExpr())

#. Click **Run**.

   There are now fewer results because value methods that return their receiver variable are no longer reported.

➤ `See this in the query console <https://lgtm.com/query/9110448975027954322/>`__

Further reading
---------------

.. include:: ../reusables/go-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
