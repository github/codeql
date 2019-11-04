Tutorial: Expressions, types and statements
===========================================

Overview
--------

This topic contains worked examples of how to write queries using the standard CodeQL library classes for C/C++ expressions, types, and statements.

Expressions and types
---------------------

Each part of an expression in C becomes an instance of the ``Expr`` class. For example, the C code ``x = x + 1`` becomes an ``AssignExpr``, an ``AddExpr``, two instances of ``VariableAccess`` and a ``Literal``. All of these CodeQL classes extend ``Expr``.

Finding assignments to zero
~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the following example we find instances of ``AssignExpr`` which assign the constant value zero:

.. code-block:: ql

   import cpp

   from AssignExpr e
   where e.getRValue().getValue().toInt() = 0
   select e, "Assigning the value 0 to something."

➤ `See this in the query console <https://lgtm.com/query/1505908086530/>`__

The ``where`` clause in this example gets the expression on the right side of the assignment, ``getRValue()``, and compares it with zero. Notice that there are no checks to make sure that the right side of the assignment is an integer or that it has a value (that is, it is compile-time constant, rather than a variable). For expressions where either of these assumptions is wrong, the associated predicate simply does not return anything and the ``where`` clause will not produce a result. You could think of it as if there is an implicit ``exists(e.getRValue().getValue().toInt())`` at the beginning of this line.

It is also worth noting that the query above would find this C code:

.. code-block:: cpp

   yPtr = NULL;

This is because the database contains a representation of the code base after the preprocessor transforms have run (for more information, see `Database generation <https://lgtm.com/help/lgtm/generate-database>`__). This means that any macro invocations, such as the ``NULL`` define used here, are expanded during the creation of the database. If you want to write queries about macros then there are some special library classes that have been designed specifically for this purpose (for example, the ``Macro``, ``MacroInvocation`` classes and predicates like ``Element.isInMacroExpansion()``). In this case, it is good that macros are expanded, but we do not want to find assignments to pointers.

Finding assignments of 0 to an integer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We can make the query more specific by defining a condition for the left side of the expression. For example:

.. code-block:: ql

   import cpp

   from AssignExpr e
   where e.getRValue().getValue().toInt() = 0
     and e.getLValue().getType().getUnspecifiedType() instanceof IntegralType
   select e, "Assigning the value 0 to an integer."

➤ `See this in the query console <https://lgtm.com/query/1505906986578/>`__

This checks that the left side of the assignment has a type that is some kind of integer. Note the call to ``Type.getUnspecifiedType()``. This resolves ``typedef`` types to their underlying types so that the query finds assignments like this one:

.. code-block:: cpp

   typedef int myInt;
   myInt i;

   i = 0;

Statements
----------

We can refine the query further using statements. In this case we use the class ``ForStmt``:

-  ``Stmt`` - C/C++ statements

   -  ``Loop``

      -  ``WhileStmt``
      -  ``ForStmt``
      -  ``DoStmt``

   -  ``ConditionalStmt``

      -  ``IfStmt``
      -  ``SwitchStmt``

   -  ``TryStmt``
   -  ``ExprStmt`` - expressions used as a statement; for example, an assignment
   -  ``Block`` - { } blocks containing more statements

Finding assignments of 0 in 'for' loop initialization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We can restrict the previous query so that it only considers assignments inside ``for`` statements by adding the ``ForStmt`` class to the query. Then we want to compare the expression to ``ForStmt.getInitialization()``:

.. code-block:: ql

   import cpp

   from AssignExpr e, ForStmt f
   // the assignment is the for loop initialization
   where e = f.getInitialization()
   ...

Unfortunately this would not quite work, because the loop initialization is actually a ``Stmt`` not an ``Expr``—the ``AssignExpr`` class is wrapped in an ``ExprStmt`` class. Instead, we need to find the closest enclosing ``Stmt`` around the expression using ``Expr.getEnclosingStmt()``:

.. code-block:: ql

   import cpp

   from AssignExpr e, ForStmt f
   // the assignment is in the 'for' loop initialization statement
   where e.getEnclosingStmt() = f.getInitialization()
     and e.getRValue().getValue().toInt() = 0
     and e.getLValue().getType().getUnspecifiedType() instanceof IntegralType
   select e, "Assigning the value 0 to an integer, inside a for loop initialization."

➤ `See this in the query console <https://lgtm.com/query/1505909016965/>`__

Finding assignments of 0 within the loop body
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We can find assignments inside the loop body using similar code with the predicate ``Loop.getStmt():``

.. code-block:: ql

   import cpp

   from AssignExpr e, ForStmt f
   // the assignment is in the for loop body
   where e.getEnclosingStmt().getParentStmt*() = f.getStmt()
     and e.getRValue().getValue().toInt() = 0
     and e.getLValue().getType().getUnderlyingType() instanceof IntegralType
   select e, "Assigning the value 0 to an integer, inside a for loop body."

➤ `See this in the query console <https://lgtm.com/query/1505901437190/>`__

Note that we replaced ``e.getEnclosingStmt()`` with ``e.getEnclosingStmt().getParentStmt*()``, to find an assignment expression that is deeply nested inside the loop body. The transitive closure modifier ``*`` here indicates that ``Stmt.getParentStmt()`` may be followed zero or more times, rather than just once, giving us the statement, its parent statement, its parent's parent statement etc.

What next?
----------

-  Explore other ways of finding types and statements using examples from the C/C++ cookbook for `types <https://help.semmle.com/wiki/label/CBCPP/type>`__ and `statements <https://help.semmle.com/wiki/label/CBCPP/statement>`__.
-  Take a look at the :doc:`Conversions and classes <conversions-classes>` and :doc:`Analyzing data flow in C/C++ <dataflow>` tutorials.
-  Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/ql-spec/language.html>`__.
-  Learn more about the query console in `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.
