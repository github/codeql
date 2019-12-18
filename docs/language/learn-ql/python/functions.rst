Tutorial: Functions
===================

This example uses the standard CodeQL class ``Function`` (see :doc:`Introducing the Python libraries <introduce-libraries-python>`).

Finding all functions called "get..."
-------------------------------------

In this example we look for all the "getters" in a program. Programmers moving to Python from Java are often tempted to write lots of getter and setter methods, rather than use properties. We might want to find those methods.

Using the member predicate ``Function.getName()``, we can list all of the getter functions in a database:

.. pull-quote::

   Tip

   Instead of copying this query, try typing the code. As you start to write a name that matches a library class, a pop-up is displayed making it easy for you to select the class that you want.

.. code-block:: ql

   import python

   from Function f
   where f.getName().matches("get%")
   select f, "This is a function called get..."

➤ `See this in the query console <https://lgtm.com/query/669220031/>`__. This query typically finds a large number of results. Usually, many of these results are for functions (rather than methods) which we are not interested in.

Finding all methods called "get..."
-----------------------------------

You can modify the query above to return more interesting results. As we are only interested in methods, we can use the ``Function.isMethod()`` predicate to refine the query.

.. code-block:: ql

   import python

   from Function f
   where f.getName().matches("get%") and f.isMethod()
   select f, "This is a method called get..."

➤ `See this in the query console <https://lgtm.com/query/690010035/>`__. This finds methods whose name starts with ``"get"``, but many of those are not the sort of simple getters we are interested in.

Finding one line methods called "get..."
----------------------------------------

We can modify the query further to include only methods whose body consists of a single statement. We do this by counting the number of lines in each method.

.. code-block:: ql

   import python

   from Function f
   where f.getName().matches("get%") and f.isMethod()
    and count(f.getAStmt()) = 1
   select f, "This function is (probably) a getter."

➤ `See this in the query console <https://lgtm.com/query/667290044/>`__. This query returns fewer results, but if you examine the results you can see that there are still refinements to be made. This is refined further in :doc:`Tutorial: Statements and expressions <statements-expressions>`.

Finding a call to a specific function
-------------------------------------

This query uses ``Call`` and ``Name`` to find calls to the function ``eval`` - which might potentially be a security hazard.

.. code-block:: ql

   import python

   from Call call, Name name
   where call.getFunc() = name and name.getId() = "eval"
   select call, "call to 'eval'."

➤ `See this in the query console <https://lgtm.com/query/6718356557331218618/>`__. Some of the demo projects on LGTM.com use this function.

The ``Call`` class represents calls in Python. The ``Call.getFunc()`` predicate gets the expression being called. ``Name.getId()`` gets the identifier (as a string) of the ``Name`` expression.
Due to the dynamic nature of Python, this query will select any call of the form ``eval(...)`` regardless of whether it is a call to the built-in function ``eval`` or not.
In a later tutorial we will see how to use the type-inference library to find calls to the built-in function ``eval`` regardless of name of the variable called.

What next?
----------

-  Experiment with the worked examples in the following tutorial topics: :doc:`Statements and expressions <statements-expressions>`, :doc:`Control flow <control-flow>`, and :doc:`Points-to analysis and type inference <pointsto-type-infer>`.
-  Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/ql-spec/language.html>`__.
