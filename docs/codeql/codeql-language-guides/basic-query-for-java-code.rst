.. _basic-query-for-java-code:

Basic query for Java and Kotlin code
====================================

Learn to write and run a simple CodeQL query using LGTM.

About the query
---------------

The query we're going to run searches for inefficient tests for empty strings. For example, Java code such as:

.. code-block:: java

    public class TestJava {
        void myJavaFun(String s) {
            boolean b = s.equals("");
        }
    }

or Kotlin code such as:

.. code-block:: kotlin

    void myKotlinFun(s: String) {
        var b = s.equals("")
    }

In either case, replacing ``s.equals("")`` with ``s.isEmpty()``
would be more efficient.

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

      from MethodAccess ma
      where
        ma.getMethod().hasName("equals") and
        ma.getArgument(0).(StringLiteral).getValue() = ""
      select ma, "This comparison to empty string is inefficient, use isEmpty() instead."

   Note that CodeQL treats Java and Kotlin as part of the same language, so even though this query starts with ``import java``, it will work for both Java and Kotlin code.

   LGTM checks whether your query compiles and, if all is well, the **Run** button changes to green to indicate that you can go ahead and run the query.

#. Click **Run**.

   The name of the project you are querying, and the ID of the most recently analyzed commit to the project, are listed below the query box. To the right of this is an icon that indicates the progress of the query operation:

   .. image:: ../images/query-progress.png
       :align: center

   .. pull-quote::

      Note

      Your query is always run against the most recently analyzed commit to the selected project.

   The query will take a few moments to return results. When the query completes, the results are displayed below the project name. The query results are listed in two columns, corresponding to the two expressions in the ``select`` clause of the query. The first column corresponds to the expression ``ma`` and is linked to the location in the source code of the project where ``ma`` occurs. The second column is the alert message.

   ➤ `Example query results <https://lgtm.com/query/6863787472564633674/>`__

   .. pull-quote::

      Note

      An ellipsis (…) at the bottom of the table indicates that the entire list is not displayed—click it to show more results.

#. If any matching code is found, click a link in the ``ma`` column to view the ``.equals`` expression in the code viewer.

   The matching ``.equals`` expression is highlighted with a yellow background in the code viewer. If any code in the file also matches a query from the standard query library for that language, you will see a red alert message at the appropriate point within the code.

About the query structure
~~~~~~~~~~~~~~~~~~~~~~~~~

After the initial ``import`` statement, this simple query comprises three parts that serve similar purposes to the FROM, WHERE, and SELECT parts of an SQL query.

+--------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------+
| Query part                                                                                       | Purpose                                                                                                           | Details                                                                                           |
+==================================================================================================+===================================================================================================================+===================================================================================================+
| ``import java``                                                                                  | Imports the standard CodeQL libraries for Java and Kotlin.                                                        | Every query begins with one or more ``import`` statements.                                        |
+--------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------+
| ``from MethodAccess ma``                                                                         | Defines the variables for the query.                                                                              | We use:                                                                                           |
|                                                                                                  | Declarations are of the form:                                                                                     |                                                                                                   |
|                                                                                                  | ``<type> <variable name>``                                                                                        | - a ``MethodAccess`` variable for call expressions                                                |
+--------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------+
| ``where ma.getMethod().hasName("equals") and ma.getArgument(0).(StringLiteral).getValue() = ""`` | Defines a condition on the variables.                                                                             | ``ma.getMethod().hasName("equals")`` restricts ``ma`` to only calls to methods call ``equals``.   |
|                                                                                                  |                                                                                                                   |                                                                                                   |
|                                                                                                  |                                                                                                                   | ``ma.getArgument(0).(StringLiteral).getValue() = ""`` says the argument must be literal ``""``.   |
+--------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------+
| ``select ma, "This comparison to empty string is inefficient, use isEmpty() instead."``          | Defines what to report for each match.                                                                            | Reports the resulting ``.equals`` expression with a string that explains the problem.             |
|                                                                                                  |                                                                                                                   |                                                                                                   |
|                                                                                                  | ``select`` statements for queries that are used to find instances of poor coding practice are always in the form: |                                                                                                   |
|                                                                                                  | ``select <program element>, "<alert message>"``                                                                   |                                                                                                   |
+--------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------+

Extend the query
----------------

Query writing is an inherently iterative process. You write a simple query and then, when you run it, you discover examples that you had not previously considered, or opportunities for improvement.

Remove false positive results
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Browsing the results of our basic query shows that it could be improved. For example, you may find results for code like:

.. code-block:: java

    public class TestJava {
        void myJavaFun(Object o) {
            boolean b = o.equals("");
        }
    }

In this case, it is not possible to simply use ``o.isEmpty()`` instead, as ``o`` has type ``Object`` rather than ``String``. One solution to this is to modify the query to only return results where the expression being tested has type ``String``:

#. Extend the where clause to include the following extra condition:

   .. code-block:: ql

    ma.getQualifier().getType() instanceof TypeString

   The ``where`` clause is now:

   .. code-block:: ql

      where
        ma.getQualifier().getType() instanceof TypeString and
        ma.getMethod().hasName("equals") and
        ma.getArgument(0).(StringLiteral).getValue() = ""

#. Click **Run**.

   There are now fewer results because ``.equals`` expressions with different types are no longer included.

➤ `See this in the query console <https://lgtm.com/query/3716567543394265485/>`__

Further reading
---------------

.. include:: ../reusables/java-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
