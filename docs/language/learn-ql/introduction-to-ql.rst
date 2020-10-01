Introduction to QL 
==================

Work through some simple exercises and examples to learn about the basics of QL and CodeQL.

Basic syntax
------------

The basic syntax of QL will look familiar to anyone who has used SQL, but it is used somewhat differently.

QL is a logic programming language, so it is built up of logical formulas. QL uses common logical connectives (such as ``and``, ``or``, and ``not``), quantifiers (such as ``forall`` and ``exists``), and other important logical concepts such as predicates.

QL also supports recursion and aggregates. This allows you to write complex recursive queries using simple QL syntax and directly use aggregates such as ``count``, ``sum``, and ``average``.

Running a query
---------------

You can try out the following examples and exercises using `CodeQL for VS Code <https://help.semmle.com/codeql/codeql-for-vscode.html>`__, or you can run them in the `query console on LGTM.com <https://lgtm.com/query>`__. Before you can run a query on LGTM.com, you need to select a language and project to query (for these logic examples, any language and project will do).

Once you have selected a language, the query console is populated with the query:

.. code-block:: ql

   import <language>

   select "hello world"

This query returns the string ``"hello world"``.

More complicated queries typically look like this:

.. code-block:: ql

   from /* ... variable declarations ... */
   where /* ... logical formulas ... */
   select /* ... expressions ... */

For example, the result of this query is the number 42:

.. code-block:: ql

   from int x, int y
   where x = 6 and y = 7
   select x * y

Note that ``int`` specifies that the **type** of ``x`` and ``y`` is 'integer'. This means that ``x`` and ``y`` are restricted to integer values. Some other common types are: ``boolean`` (``true`` or ``false``), ``date``, ``float``, and ``string``.

Simple exercises
----------------

You can write simple queries using the some of the basic functions that are available for the ``int``, ``date``, ``float``, ``boolean`` and ``string`` types. To apply a function, append it to the argument. For example, ``1.toString()`` converts the value ``1`` to a string. Notice that as you start typing a function, a pop-up is displayed making it easy to select the function that you want. Also note that you can apply multiple functions in succession. For example, ``100.log().sqrt()`` first takes the natural logarithm of 100 and then computes the square root of the result.

Exercise 1
~~~~~~~~~~

Write a query which returns the length of the string ``"lgtm"``. (Hint: `here <https://help.semmle.com/QL/ql-spec/language.html#built-ins-for-string>`__ is the list of the functions that can be applied to strings.)

➤ `See answer in the query console on LGTM.com <https://lgtm.com/query/2103060623/>`__

There is often more than one way to define a query. For example, we can also write the above query in the shorter form:

.. code-block:: ql

   select "lgtm".length()

Exercise 2
~~~~~~~~~~

Write a query which returns the sine of the minimum of ``3^5`` (``3`` raised to the power ``5``) and ``245.6``.

➤ `See answer in the query console on LGTM.com <https://lgtm.com/query/2093780343/>`__

Exercise 3
~~~~~~~~~~

Write a query which returns the opposite of the boolean ``false``.

➤ `See answer in the query console on LGTM.com <https://lgtm.com/query/2093780344/>`__

Exercise 4
~~~~~~~~~~

Write a query which computes the number of days between June 10 and September 28, 2017.

➤ `See answer in the query console on LGTM.com <https://lgtm.com/query/2100260596/>`__

Example query with multiple results
-----------------------------------

The exercises above all show queries with exactly one result, but in fact many queries have multiple results. For example, the following query computes all `Pythagorean triples <https://en.wikipedia.org/wiki/Pythagorean_triple>`__ between 1 and 10:

.. code-block:: ql

   from int x, int y, int z
   where x in [1..10] and y in [1..10] and z in [1..10] and
         x*x + y*y = z*z
   select x, y, z

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2100790036/>`__

To simplify the query, we can introduce a class ``SmallInt`` representing the integers between 1 and 10. We can also define a predicate ``square()`` on integers in that class. Defining classes and predicates in this way makes it easy to reuse code without having to repeat it every time.

.. code-block:: ql

   class SmallInt extends int {
     SmallInt() { this in [1..10] }
     int square() { result = this*this }
   }

   from SmallInt x, SmallInt y, SmallInt z
   where x.square() + y.square() = z.square()
   select x, y, z

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2101340747/>`__

Example CodeQL queries
----------------------

The previous examples used the primitive types built in to QL. Although we chose a project to query, we didn't use the information in that project's database.
The following example queries *do* use these databases and give you an idea of how to use CodeQL to analyze projects.

Queries using the CodeQL libraries can find errors and uncover variants of important security vulnerabilities in codebases.
Visit `GitHub Security Lab <https://securitylab.github.com/>`__ to read about examples of vulnerabilities that we have recently found in open source projects.

To import the CodeQL library for a specific programming language, type ``import <language>`` at the start of the query.

.. code-block:: ql

   import python

   from Function f
   where count(f.getAnArg()) > 7
   select f

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2096810474/>`__. The ``from`` clause defines a variable ``f`` representing a Python function. The ``where`` part limits the functions ``f`` to those with more than 7 arguments. Finally, the ``select`` clause lists these functions.

.. code-block:: ql

   import javascript

   from Comment c
   where c.getText().regexpMatch("(?si).*\\bTODO\\b.*")
   select c

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2101530483/>`__. The ``from`` clause defines a variable ``c`` representing a JavaScript comment. The ``where`` part limits the comments ``c`` to those containing the word ``"TODO"``. The ``select`` clause lists these comments.

.. code-block:: ql

   import java

   from Parameter p
   where not exists(p.getAnAccess())
   select p

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2098670762/>`__. The ``from`` clause defines a variable ``p`` representing a Java parameter. The ``where`` clause finds unused parameters by limiting the parameters ``p`` to those which are not accessed. Finally, the ``select`` clause lists these parameters.

Further reading
---------------

-  To find out more about how to write your own queries, try working through the ":doc:`QL tutorials <beginner/ql-tutorials>`."
-  For an overview of the other available resources, see ":doc:`Learning CodeQL <../index>`."
-  For a more technical description of the underlying language, see the "`QL language reference <https://help.semmle.com/QL/ql-handbook>`__."