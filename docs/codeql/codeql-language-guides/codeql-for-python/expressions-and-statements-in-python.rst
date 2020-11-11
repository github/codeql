.. _expressions-and-statements-in-python:

Expressions and statements in Python
====================================

You can use syntactic classes from the CodeQL library to explore how Python expressions and statements are used in a code base.

Statements
----------

The bulk of Python code takes the form of statements. Each different type of statement in Python is represented by a separate CodeQL class.

Here is the full class hierarchy:

-  ``Stmt`` – A statement

   -  ``Assert`` – An ``assert`` statement
   -  ``Assign``

      -  ``AssignStmt`` – An assignment statement, ``x = y``
      -  ``ClassDef`` – A class definition statement
      -  ``FunctionDef`` – A function definition statement

   -  ``AugAssign`` – An augmented assignment, ``x += y``
   -  ``Break`` – A ``break`` statement
   -  ``Continue`` – A ``continue`` statement
   -  ``Delete`` – A ``del`` statement
   -  ``ExceptStmt`` – The ``except`` part of a ``try`` statement
   -  ``Exec`` – An ``exec`` statement
   -  ``For`` – A ``for`` statement
   -  ``Global`` – A ``global`` statement
   -  ``If`` – An ``if`` statement
   -  ``ImportStar`` – A ``from xxx import *`` statement
   -  ``Import`` – Any other ``import`` statement
   -  ``Nonlocal`` – A ``nonlocal`` statement
   -  ``Pass`` – A ``pass`` statement
   -  ``Print`` – A ``print`` statement (Python 2 only)
   -  ``Raise`` – A ``raise`` statement
   -  ``Return`` – A ``return`` statement
   -  ``Try`` – A ``try`` statement
   -  ``While`` – A ``while`` statement
   -  ``With`` – A ``with`` statement

Example finding redundant 'global' statements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``global`` statement in Python declares a variable with a global (module-level) scope, when it would otherwise be local. Using the ``global`` statement outside a class or function is redundant as the variable is already global.

.. code-block:: ql

   import python

   from Global g
   where g.getScope() instanceof Module
   select g

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/686330052/>`__. None of the demo projects on LGTM.com has a global statement that matches this pattern.

The line: ``g.getScope() instanceof Module`` ensures that the ``Scope`` of ``Global g`` is a ``Module``, rather than a class or function.

Example finding 'if' statements with redundant branches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An ``if`` statement where one branch is composed of just ``pass`` statements could be simplified by negating the condition and dropping the ``else`` clause.

.. code-block:: python

   if cond():
       pass
   else:
       do_something

To find statements like this that could be simplified we can write a query.

.. code-block:: ql

   import python

   from If i, StmtList l
   where (l = i.getBody() or l = i.getOrelse())
     and forall(Stmt p | p = l.getAnItem() | p instanceof Pass)
   select i

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/672230053/>`__. Many projects have some ``if`` statements that match this pattern.

The line: ``(l = i.getBody() or l = i.getOrelse())`` restricts the ``StmtList l`` to branches of the ``if`` statement.

The line: ``forall(Stmt p | p = l.getAnItem() | p instanceof Pass)`` ensures that all statements in ``l`` are ``pass`` statements.

Expressions
-----------

Each kind of Python expression has its own class. Here is the full class hierarchy:

-  ``Expr`` – An expression

   -  ``Attribute`` – An attribute, ``obj.attr``
   -  ``BinaryExpr`` – A binary operation, ``x+y``
   -  ``BoolExpr`` – Short circuit logical operations, ``x and y``, ``x or y``
   -  ``Bytes`` – A bytes literal, ``b"x"`` or (in Python 2) ``"x"``
   -  ``Call`` – A function call, ``f(arg)``
   -  ``Compare`` – A comparison operation, ``0 < x < 10``
   -  ``Dict`` – A dictionary literal, ``{'a': 2}``
   -  ``DictComp`` – A dictionary comprehension, ``{k: v for ...}``
   -  ``Ellipsis`` – An ellipsis expression, ``...``
   -  ``GeneratorExp`` – A generator expression
   -  ``IfExp`` – A conditional expression, ``x if cond else y``
   -  ``ImportExpr`` – An artificial expression representing the module imported
   -  ``ImportMember – A``\ n artificial expression representing importing a value from a module (part of an ``from xxx import *`` statement)
   -  ``Lambda – A lambda expression``
   -  ``List`` – A list literal, ``['a', 'b']``
   -  ``ListComp`` – A list comprehension, ``[x for ...]``
   -  ``Name`` – A reference to a variable, ``var``
   -  ``Num`` – A numeric literal, ``3`` or ``4.2``

      -  ``FloatLiteral``
      -  ``ImaginaryLiteral``
      -  ``IntegerLiteral``

   -  ``Repr`` – A backticks expression, ``x`` (Python 2 only)
   -  ``Set`` – A set literal, ``{'a', 'b'}``
   -  ``SetComp`` – A set comprehension, ``{x for ...}``
   -  ``Slice`` – A slice; the ``0:1`` in the expression ``seq[0:1]``
   -  ``Starred`` – A starred expression, ``*x`` in the context of a multiple assignment: ``y, *x = 1,2,3`` (Python 3 only)
   -  ``StrConst`` – A string literal. In Python 2 either bytes or unicode. In Python 3 only unicode.
   -  ``Subscript`` – A subscript operation, ``seq[index]``
   -  ``UnaryExpr`` – A unary operation, ``-x``
   -  ``Unicode`` – A unicode literal, ``u"x"`` or (in Python 3) ``"x"``
   -  ``Yield`` – A ``yield`` expression
   -  ``YieldFrom`` – A ``yield from`` expression (Python 3.3+)

Example finding comparisons to integer or string literals using 'is'
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Python implementations commonly cache small integers and single character strings, which means that comparisons such as the following often work correctly, but this is not guaranteed and we might want to check for them.

.. code-block:: python

   x is 10
   x is "A"

We can check for these using a query.

.. code-block:: ql

   import python

   from Compare cmp, Expr literal
   where (literal instanceof StrConst or literal instanceof Num)
     and cmp.getOp(0) instanceof Is and cmp.getComparator(0) = literal
   select cmp

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/688180010/>`__. Two of the demo projects on LGTM.com use this pattern: *saltstack/salt* and *openstack/nova*.

The clause ``cmp.getOp(0) instanceof Is and cmp.getComparator(0) = literal`` checks that the first comparison operator is "is" and that the first comparator is a literal.

.. pull-quote::

   Tip

   We have to use ``cmp.getOp(0)`` and ``cmp.getComparator(0)``\ as there is no ``cmp.getOp()`` or ``cmp.getComparator()``. The reason for this is that a ``Compare`` expression can have multiple operators. For example, the expression ``3 < x < 7`` has two operators and two comparators. You use ``cmp.getComparator(0)`` to get the first comparator (in this example the ``x``) and ``cmp.getComparator(1)`` to get the second comparator (in this example the ``7``).

Example finding duplicates in dictionary literals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If there are duplicate keys in a Python dictionary, then the second key will overwrite the first, which is almost certainly a mistake. We can find these duplicates with CodeQL, but the query is more complex than previous examples and will require us to write a ``predicate`` as a helper.

.. code-block:: ql

   import python

   predicate same_key(Expr k1, Expr k2) {
     k1.(Num).getN() = k2.(Num).getN()
     or
     k1.(StrConst).getText() = k2.(StrConst).getText()
   }

   from Dict d, Expr k1, Expr k2
   where k1 = d.getAKey() and k2 = d.getAKey()
     and k1 != k2 and same_key(k1, k2)
   select k1, "Duplicate key in dict literal"

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/663330305/>`__. When we ran this query on LGTM.com, the source code of the *saltstack/salt* project contained an example of duplicate dictionary keys. The results were also highlighted as alerts by the standard "Duplicate key in dict literal" query. Two of the other demo projects on LGTM.com refer to duplicate dictionary keys in library files. For more information, see `Duplicate key in dict literal <https://lgtm.com/rules/3980087>`__ on LGTM.com.

The supporting predicate ``same_key`` checks that the keys have the same identifier. Separating this part of the logic into a supporting predicate, instead of directly including it in the query, makes it easier to understand the query as a whole. The casts defined in the predicate restrict the expression to the type specified and allow predicates to be called on the type that is cast-to. For example:

.. code-block:: ql

   x = k1.(Num).getN()

is equivalent to

.. code-block:: ql

   exists(Num num | num = k1 | x = num.getN())

The short version is usually used as this is easier to read.

Example finding Java-style getters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Returning to the example from ":doc:`Functions in Python <functions-in-python>`," the query identified all methods with a single line of code and a name starting with ``get``.

.. code-block:: ql

   import python

   from Function f
   where f.getName().matches("get%") and f.isMethod()
       and count(f.getAStmt()) = 1
   select f, "This function is (probably) a getter."

This basic query can be improved by checking that the one line of code is a Java-style getter of the form ``return self.attr``.

.. code-block:: ql

   import python

   from Function f, Return ret, Attribute attr, Name self
   where f.getName().matches("get%") and f.isMethod()
       and ret = f.getStmt(0) and ret.getValue() = attr
       and attr.getObject() = self and self.getId() = "self"
   select f, "This function is a Java-style getter."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/669220054/>`__. Of the demo projects on LGTM.com, only the *openstack/nova* project has examples of functions that appear to be Java-style getters.

.. code-block:: ql

   ret = f.getStmt(0) and ret.getValue() = attr

This condition checks that the first line in the method is a return statement and that the expression returned (``ret.getValue()``) is an ``Attribute`` expression. Note that the equality ``ret.getValue() = attr`` means that ``ret.getValue()`` is restricted to ``Attribute``\ s, since ``attr`` is an ``Attribute``.

.. code-block:: ql

   attr.getObject() = self and self.getId() = "self"

This condition checks that the value of the attribute (the expression to the left of the dot in ``value.attr``) is an access to a variable called ``"self"``.

Class and function definitions
------------------------------

As Python is a dynamically typed language, class, and function definitions are executable statements. This means that a class statement is both a statement and a scope containing statements. To represent this cleanly the class definition is broken into a number of parts. At runtime, when a class definition is executed a class object is created and then assigned to a variable of the same name in the scope enclosing the class. This class is created from a code-object representing the source code for the body of the class. To represent this the ``ClassDef`` class (which represents a ``class`` statement) subclasses ``Assign``. The ``Class`` class, which represents the body of the class, can be accessed via the ``ClassDef.getDefinedClass()``. ``FunctionDef`` and ``Function`` are handled similarly.

Here is the relevant part of the class hierarchy:

-  ``Stmt``

   -  ``Assign``

      -  ``ClassDef``
      -  ``FunctionDef``

-  ``Scope``

   -  ``Class``
   -  ``Function``

Further reading
---------------

.. include:: ../../reusables/python-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst

