.. _introduction-to-ql:

Introduction to QL
==================

Work through some simple exercises and examples to learn about the basics of QL and CodeQL.

Basic syntax
------------

The basic syntax of QL will look familiar to anyone who has used SQL, but it is used somewhat differently.

QL is a logic programming language, so it is built up of logical formulas. QL uses common logical connectives (such as ``and``, ``or``, and ``not``), quantifiers (such as ``forall`` and ``exists``), and other important logical concepts such as predicates.

QL also supports recursion and aggregates. This allows you to write complex recursive queries using simple QL syntax and directly use aggregates such as ``count``, ``sum``, and ``average``.

.. include:: ../reusables/codespaces-template-note.rst

Running a query
---------------

You can try out the following examples and exercises using `CodeQL for VS Code <https://docs.github.com/en/code-security/codeql-for-vs-code/>`__ or the `CodeQL template <https://github.com/codespaces/new?template_repository=github/codespaces-codeql>`__ on GitHub Codespaces.

Here is an example of a basic query:

.. code-block:: ql

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

Exercise 1 - Strings
~~~~~~~~~~~~~~~~~~~~

Write a query which returns the length of the string ``"lgtm"``. (Hint: `here <https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#built-ins-for-string>`__ is the list of the functions that can be applied to strings.)

➤ `Check your answer <#exercise-1>`__

Exercise 2 - Numbers
~~~~~~~~~~~~~~~~~~~~

Write a query which returns the sine of the minimum of ``3^5`` (``3`` raised to the power ``5``) and ``245.6``.

➤ `Check your answer <#exercise-2>`__

Exercise 3 - Booleans
~~~~~~~~~~~~~~~~~~~~~

Write a query which returns the opposite of the boolean ``false``.

➤ `Check your answer <#exercise-3>`__

Exercise 4 - Dates
~~~~~~~~~~~~~~~~~~

Write a query which computes the number of days between June 10 and September 28, 2017.

➤ `Check your answer <#exercise-4>`__

Example query with multiple results
-----------------------------------

The exercises above all show queries with exactly one result, but in fact many queries have multiple results. For example, the following query computes all `Pythagorean triples <https://en.wikipedia.org/wiki/Pythagorean_triple>`__ between 1 and 10:

.. code-block:: ql

   from int x, int y, int z
   where x in [1..10] and y in [1..10] and z in [1..10] and
         x*x + y*y = z*z
   select x, y, z

To simplify the query, we can introduce a class ``SmallInt`` representing the integers between 1 and 10. We can also define a predicate ``square()`` on integers in that class. Defining classes and predicates in this way makes it easy to reuse code without having to repeat it every time.

.. code-block:: ql

   class SmallInt extends int {
     SmallInt() { this in [1..10] }
     int square() { result = this*this }
   }

   from SmallInt x, SmallInt y, SmallInt z
   where x.square() + y.square() = z.square()
   select x, y, z

Example CodeQL queries
----------------------

The previous examples used the primitive types built in to QL. Although we chose a project to query, we didn't use the information in that project's database.
The following example queries *do* use these databases and give you an idea of how to use CodeQL to analyze projects.

Queries using the CodeQL libraries can find errors and uncover variants of important security vulnerabilities in codebases.
Visit `GitHub Security Lab <https://securitylab.github.com/>`__ to read about examples of vulnerabilities that we have recently found in open source projects.

Before you can run the following examples, you will need to install the CodeQL extension for Visual Studio Code. For more information, see `Installing CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__ in the GitHub documentation. You will also need to import and select a database in the corresponding programming language.

To import the CodeQL library for a specific programming language, type ``import <language>`` at the start of the query.

.. code-block:: ql

   import python

   from Function f
   where count(f.getAnArg()) > 7
   select f

The ``from`` clause defines a variable ``f`` representing a Python function. The ``where`` part limits the functions ``f`` to those with more than 7 arguments. Finally, the ``select`` clause lists these functions.

.. code-block:: ql

   import javascript

   from Comment c
   where c.getText().regexpMatch("(?si).*\\bTODO\\b.*")
   select c

The ``from`` clause defines a variable ``c`` representing a JavaScript comment. The ``where`` part limits the comments ``c`` to those containing the word ``"TODO"``. The ``select`` clause lists these comments.

.. code-block:: ql

   import java

   from Parameter p
   where not exists(p.getAnAccess())
   select p

The ``from`` clause defines a variable ``p`` representing a Java parameter. The ``where`` clause finds unused parameters by limiting the parameters ``p`` to those which are not accessed. Finally, the ``select`` clause lists these parameters.

Further reading
---------------

-  For a more technical description of the underlying language, see the ":ref:`QL language reference <ql-language-reference>`."

--------------

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   from string s
   where s = "lgtm"
   select s.length()

There is often more than one way to define a query. For example, we can also write the above query in the shorter form:

.. code-block:: ql

   select "lgtm".length()

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   from float x, float y
   where x = 3.pow(5) and y = 245.6
   select x.minimum(y).sin()

Exercise 3
~~~~~~~~~~

.. code-block:: ql

   from boolean b
   where b = false
   select b.booleanNot()

Exercise 4
~~~~~~~~~~

.. code-block:: ql

   from date start, date end
   where start = "10/06/2017".toDate() and end = "28/09/2017".toDate()
   select start.daysTo(end)
