.. _functions-in-cpp:

Functions in C and C++
=======================

You can use CodeQL to explore functions in C and C++ code.

Overview
--------

The standard CodeQL library for C and C++ represents functions using the ``Function`` class (see :doc:`CodeQL libraries for C and C++ <codeql-library-for-cpp>`).

The example queries in this topic explore some of the most useful library predicates for querying functions.

Finding all static functions
----------------------------

Using the member predicate ``Function.isStatic()`` we can list all the static functions in a database:

.. code-block:: ql

   import cpp

   from Function f
   where f.isStatic()
   select f, "This is a static function."

This query is very general, so there are probably too many results to be interesting for most nontrivial projects.

Finding functions that are not called
-------------------------------------

It might be more interesting to find functions that are not called, using the standard CodeQL ``FunctionCall`` class from the **abstract syntax tree** category (see :doc:`CodeQL libraries for C and C++ <codeql-library-for-cpp>`). The ``FunctionCall`` class can be used to identify places where a function is actually used, and it is related to ``Function`` through the ``FunctionCall.getTarget()`` predicate.

.. code-block:: ql

   import cpp

   from Function f
   where not exists(FunctionCall fc | fc.getTarget() = f)
   select f, "This function is never called."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505891246456/>`__

The new query finds functions that are not the target of any ``FunctionCall``—in other words, functions that are never called. You may be surprised by how many results the query finds. However, if you examine the results, you can see that many of the functions it finds are used indirectly. To create a query that finds only unused functions, we need to refine the query and exclude other ways of using a function.

Excluding functions that are referenced with a function pointer
---------------------------------------------------------------

You can modify the query to remove functions where a function pointer is used to reference the function:

.. code-block:: ql

   import cpp

   from Function f
   where not exists(FunctionCall fc | fc.getTarget() = f)
     and not exists(FunctionAccess fa | fa.getTarget() = f)
   select f, "This function is never called, or referenced with a function pointer."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505890446605/>`__

This query returns fewer results. However, if you examine the results then you can probably still find potential refinements.

For example, there is a more complicated LGTM `query <https://lgtm.com/rules/2152580467/>`__ that finds unused static functions. To see the code for this query, click **Open in query console** at the top of the page.

   You can explore the definition of an element in the standard libraries and see what predicates are available. Use the keyboard **F3** button to open the definition of any element. Alternatively, hover over the element and click **Jump to definition** in the tooltip displayed. The library file is opened in a new tab with the definition highlighted.

Finding a specific function
---------------------------

This query uses ``Function`` and ``FunctionCall`` to find calls to the function ``sprintf`` that have a variable format string—which is potentially a security hazard.

.. code-block:: ql

   import cpp

   from FunctionCall fc
   where fc.getTarget().getQualifiedName() = "sprintf"
     and not fc.getArgument(1) instanceof StringLiteral
   select fc, "sprintf called with variable format string."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505889506751/>`__

This uses:

-  ``Declaration.getQualifiedName()`` to identify calls to the specific function ``sprintf``.
-  ``FunctionCall.getArgument(1)`` to fetch the format string argument.

Note that we could have used ``Declaration.getName()``, but ``Declaration.getQualifiedName()`` is a better choice because it includes the namespace. For example: ``getName()`` would return ``vector`` where ``getQualifiedName`` would return ``std::vector``.

The LGTM version of this query is considerably more complicated, but if you look carefully you will find that its structure is the same. See `Non-constant format string <https://lgtm.com/rules/2152810612/>`__ and click **Open in query console** at the top of the page.

Further reading
---------------

.. include:: ../../reusables/cpp-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
