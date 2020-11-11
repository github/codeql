.. _codeql-library-for-python:

CodeQL library for Python
=========================

When you need to analyze a Python program, you can make use of the large collection of classes in the CodeQL library for Python.

About the CodeQL library for Python
-----------------------------------

The CodeQL library for each programming language uses classes with abstractions and predicates to present data in an object-oriented form. 

Each CodeQL library is implemented as a set of QL modules, that is, files with the extension ``.qll``. The module ``python.qll`` imports all the core Python library modules, so you can include the complete library by beginning your query with:

.. code-block:: ql

   import python

The CodeQL library for Python incorporates a large number of classes. Each class corresponds either to one kind of entity in Python source code or to an entity that can be derived from the source code using static analysis. These classes can be divided into four categories:

-  **Syntactic** - classes that represent entities in the Python source code.
-  **Control flow** - classes that represent entities from the control flow graphs.
-  **Type inference** - classes that represent the inferred values and types of entities in the Python source code.
-  **Taint tracking** - classes that represent the source, sinks and kinds of taint used to implement taint-tracking queries.

Syntactic classes
-----------------

This part of the library represents the Python source code. The ``Module``, ``Class``, and ``Function`` classes correspond to Python modules, classes, and functions respectively, collectively these are known as ``Scope`` classes. Each ``Scope`` contains a list of statements each of which is represented by a subclass of the class ``Stmt``. Statements themselves can contain other statements or expressions which are represented by subclasses of ``Expr``. Finally, there are a few additional classes for the parts of more complex expressions such as list comprehensions. Collectively these classes are subclasses of ``AstNode`` and form an Abstract syntax tree (AST). The root of each AST is a ``Module``. Symbolic information is attached to the AST in the form of variables (represented by the class ``Variable``). For more information, see `Abstract syntax tree <http://en.wikipedia.org/wiki/Abstract_syntax_tree>`__ and `Symbolic information <http://en.wikipedia.org/wiki/Symbol_table>`__ on Wikipedia.

Scope
^^^^^

A Python program is a group of modules. Technically a module is just a list of statements, but we often think of it as composed of classes and functions. These top-level entities, the module, class, and function are represented by the three CodeQL classes `Module <https://help.semmle.com/qldoc/python/semmle/python/Module.qll/type.Module$Module.html>`__, `Class <https://help.semmle.com/qldoc/python/semmle/python/Class.qll/type.Class$Class.html>`__ and `Function <https://help.semmle.com/qldoc/python/semmle/python/Function.qll/type.Function$Function.html>`__ which are all subclasses of ``Scope``.

-  ``Scope``

   -  ``Module``
   -  ``Class``
   -  ``Function``

All scopes are basically a list of statements, although ``Scope`` classes have additional attributes such as names. For example, the following query finds all functions whose scope (the scope in which they are declared) is also a function:

.. code-block:: ql

   import python

   from Function f
   where f.getScope() instanceof Function
   select f

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/665620040/>`__. Many projects have nested functions.

Statement
^^^^^^^^^

A statement is represented by the `Stmt <https://help.semmle.com/qldoc/python/semmle/python/Stmts.qll/type.Stmts$Stmt.html>`__ class which has about 20 subclasses representing the various kinds of statements, such as the ``Pass`` statement, the ``Return`` statement or the ``For`` statement. Statements are usually made up of parts. The most common of these is the expression, represented by the ``Expr`` class. For example, take the following Python ``for`` statement:

.. code-block:: python

   for var in seq:
       pass
   else:
       return 0

The `For <https://help.semmle.com/qldoc/python/semmle/python/Stmts.qll/type.Stmts$For.html>`__ class representing the ``for`` statement has a number of member predicates to access its parts:

-  ``getTarget()`` returns the ``Expr`` representing the variable ``var``.
-  ``getIter()`` returns the ``Expr`` resenting the variable ``seq``.
-  ``getBody()`` returns the statement list body.
-  ``getStmt(0)`` returns the pass ``Stmt``.
-  ``getOrElse()`` returns the ``StmtList`` containing the return statement.

Expression
^^^^^^^^^^

Most statements are made up of expressions. The `Expr <https://help.semmle.com/qldoc/python/semmle/python/Exprs.qll/type.Exprs$Expr.html>`__ class is the superclass of all expression classes, of which there are about 30 including calls, comprehensions, tuples, lists and arithmetic operations. For example, the Python expression ``a+2`` is represented by the ``BinaryExpr`` class:

-  ``getLeft()`` returns the ``Expr`` representing the ``a``.
-  ``getRight()`` returns the ``Expr`` representing the ``2``.

As an example, to find expressions of the form ``a+2`` where the left is a simple name and the right is a numeric constant we can use the following query:

**Finding expressions of the form "a+2"**

.. code-block:: ql

   import python

   from BinaryExpr bin
   where bin.getLeft() instanceof Name and bin.getRight() instanceof Num
   select bin

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/669950026/>`__. Many projects include examples of this pattern.

Variable
^^^^^^^^

Variables are represented by the `Variable <https://help.semmle.com/qldoc/python/semmle/python/Variables.qll/type.Variables$Variable.html>`__ class in the CodeQL library. There are two subclasses, ``LocalVariable`` for function-level and class-level variables and ``GlobalVariable`` for module-level variables.

Other source code elements
^^^^^^^^^^^^^^^^^^^^^^^^^^

Although the meaning of the program is encoded by the syntactic elements, ``Scope``, ``Stmt`` and ``Expr`` there are some parts of the source code not covered by the abstract syntax tree. The most useful of these is the `Comment <https://help.semmle.com/qldoc/python/semmle/python/Comment.qll/type.Comment$Comment.html>`__ class which describes comments in the source code.

Examples
^^^^^^^^

Each syntactic element in Python source is recorded in the CodeQL database. These can be queried via the corresponding class. Let us start with a couple of simple examples.

1. Finding all ``finally`` blocks
'''''''''''''''''''''''''''''''''

For our first example, we can find all ``finally`` blocks by using the ``Try`` class:

**Find all** ``finally`` **blocks**

.. code-block:: ql

   import python

   from Try t
   select t.getFinalbody()

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/659662193/>`__. Many projects include examples of this pattern.

2. Finding ``except`` blocks that do nothing
''''''''''''''''''''''''''''''''''''''''''''

For our second example, we can use a simplified version of a query from the standard query set. We look for all ``except`` blocks that do nothing.

A block that does nothing is one that contains no statements except ``pass`` statements. We can encode this as:

.. code-block:: ql

   not exists(Stmt s | s = ex.getAStmt() | not s instanceof Pass)

where ``ex`` is an ``ExceptStmt`` and ``Pass`` is the class representing ``pass`` statements. Instead of using the double negative, "**no** \ *statements that are* \ **not** \ *pass statements"*, this can also be expressed positively, *"all statements must be pass statements."* The positive form is expressed using the ``forall`` quantifier:

.. code-block:: ql

   forall(Stmt s | s = ex.getAStmt() | s instanceof Pass)

Both forms are equivalent. Using the positive expression, the whole query looks like this:

**Find pass-only** ``except`` **blocks**

.. code-block:: ql

   import python

   from ExceptStmt ex
   where forall(Stmt s | s = ex.getAStmt() | s instanceof Pass)
   select ex

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/690010036/>`__. Many projects include pass-only ``except`` blocks.

Summary
^^^^^^^

The most commonly used standard classes in the syntactic part of the library are organized as follows:

``Module``, ``Class``, ``Function``, ``Stmt``, and ``Expr`` - they are all subclasses of `AstNode <https://help.semmle.com/qldoc/python/semmle/python/AstExtended.qll/type.AstExtended$AstNode.html>`__.

Abstract syntax tree
''''''''''''''''''''

-  ``AstNode``

   -  ``Module`` – A Python module
   -  ``Class`` – The body of a class definition
   -  ``Function`` – The body of a function definition
   -  ``Stmt`` – A statement

      -  ``Assert`` – An ``assert`` statement
      -  ``Assign`` – An assignment

         -  ``AssignStmt`` – An assignment statement, ``x = y``
         -  ``ClassDef`` – A class definition statement
         -  ``FunctionDef`` – A function definition statement

      -  ``AugAssign`` – An augmented assignment, ``x += y``
      -  ``Break`` – A ``break`` statement
      -  ``Continue`` – A ``continue`` statement
      -  ``Delete`` – A ``del`` statement
      -  ``ExceptStmt`` – The ``except`` part of a ``try`` statement
      -  ``Exec`` – An exec statement
      -  ``For`` – A ``for`` statement
      -  ``If`` – An ``if`` statement
      -  ``Pass`` – A ``pass`` statement
      -  ``Print`` – A ``print`` statement (Python 2 only)
      -  ``Raise`` – A raise statement
      -  ``Return`` – A ``return`` statement
      -  ``Try`` – A ``try`` statement
      -  ``While`` – A ``while`` statement
      -  ``With`` – A ``with`` statement

   -  ``Expr`` – An expression

      -  ``Attribute`` – An attribute, ``obj.attr``
      -  ``Call`` – A function call, ``f(arg)``
      -  ``IfExp`` – A conditional expression, ``x if cond else y``
      -  ``Lambda – A lambda expression``
      -  ``Yield`` – A ``yield`` expression
      -  ``Bytes`` – A bytes literal, ``b"x"`` or (in Python 2) ``"x"``
      -  ``Unicode`` – A unicode literal, ``u"x"`` or (in Python 3) ``"x"``
      -  ``Num`` – A numeric literal, ``3`` or ``4.2``

         -  ``IntegerLiteral``
         -  ``FloatLiteral``
         -  ``ImaginaryLiteral``

      -  ``Dict`` – A dictionary literal, ``{'a': 2}``
      -  ``Set`` – A set literal, ``{'a', 'b'}``
      -  ``List`` – A list literal, ``['a', 'b']``
      -  ``Tuple`` – A tuple literal, ``('a', 'b')``
      -  ``DictComp`` – A dictionary comprehension, ``{k: v for ...}``
      -  ``SetComp`` – A set comprehension, ``{x for ...}``
      -  ``ListComp`` – A list comprehension, ``[x for ...]``
      -  ``GenExpr`` – A generator expression, ``(x for ...)``
      -  ``Subscript`` – A subscript operation, ``seq[index]``
      -  ``Name`` – A reference to a variable, ``var``
      -  ``UnaryExpr`` – A unary operation, ``-x``
      -  ``BinaryExpr`` – A binary operation, ``x+y``
      -  ``Compare`` – A comparison operation, ``0 < x < 10``
      -  ``BoolExpr`` – Short circuit logical operations, ``x and y``, ``x or y``

Variables
'''''''''

-  ``Variable`` – A variable

   -  ``LocalVariable`` – A variable local to a function or a class
   -  ``GlobalVariable`` – A module level variable

Other
'''''

-  ``Comment`` – A comment

Control flow classes
--------------------

This part of the library represents the control flow graph of each ``Scope`` (classes, functions, and modules). Each ``Scope`` contains a graph of ``ControlFlowNode`` elements. Each scope has a single entry point and at least one (potentially many) exit points. To speed up control and data flow analysis, control flow nodes are grouped into basic blocks. For more information, see `Basic block <http://en.wikipedia.org/wiki/Basic_block>`__ on Wikipedia.

Example
^^^^^^^

If we want to find the longest sequence of code without any branches, we need to consider control flow. A ``BasicBlock`` is, by definition, a sequence of code without any branches, so we just need to find the longest ``BasicBlock``.

First of all we introduce a simple predicate ``bb_length()`` which relates ``BasicBlock``\ s to their length.

.. code-block:: ql

   int bb_length(BasicBlock b) {
       result = max(int i | exists(b.getNode(i))) + 1
   }

Each ``ControlFlowNode`` within a ``BasicBlock`` is numbered consecutively, starting from zero, therefore the length of a ``BasicBlock`` is equal to one more than the largest index within that ``BasicBlock``.

Using this predicate we can select the longest ``BasicBlock`` by selecting the ``BasicBlock`` whose length is equal to the maximum length of any ``BasicBlock``:

**Find the longest sequence of code without branches**

.. code-block:: ql

   import python

   int bb_length(BasicBlock b) {
       result = max(int i | exists(b.getNode(i)) | i) + 1
   }

   from BasicBlock b
   where bb_length(b) = max(bb_length(_))
   select b

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/666730036/>`__. When we ran it on the LGTM.com demo projects, the *openstack/nova* and *ytdl-org/youtube-dl* projects both contained source code results for this query.

.. pull-quote::

   Note

   The special underscore variable ``_`` means any value; so ``bb_length(_)`` is the length of any block.

Summary
^^^^^^^

The classes in the control-flow part of the library are:

-  `ControlFlowNode <https://help.semmle.com/qldoc/python/semmle/python/Flow.qll/type.Flow$ControlFlowNode.html>`__ – A control-flow node. There is a one-to-many relation between AST nodes and control-flow nodes.
-  `BasicBlock <https://help.semmle.com/qldoc/python/semmle/python/Flow.qll/type.Flow$BasicBlock.html>`__ – A non branching list of control-flow nodes.


Type-inference classes
----------------------

The CodeQL library for Python also supplies some classes for accessing the inferred types of values. The classes ``Value`` and ``ClassValue`` allow you to query the possible classes that an expression may have at runtime. 

Example
^^^^^^^

For example, which ``ClassValue``\ s are iterable can be determined using the query:

**Find iterable "ClassValue"s**

.. code-block:: ql

   import python

   from ClassValue cls
   where cls.hasAttribute("__iter__")
   select cls

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/5151030165280978402/>`__ This query returns a list of classes for the projects analyzed. If you want to include the results for ``builtin`` classes, which do not have any Python source code, show the non-source results. For more information, see `builtin classes <http://docs.python.org/library/stdtypes.html>`__ in the Python documentation.

Summary
^^^^^^^

-  `Value <https://help.semmle.com/qldoc/python/semmle/python/objects/ObjectAPI.qll/type.ObjectAPI$Value.html>`__

   -  ``ClassValue``
   -  ``CallableValue``
   -  ``ModuleValue``

For more information about these classes, see ":doc:`Pointer analysis and type inference in Python <pointer-analysis-and-type-inference-in-python>`."

Taint-tracking classes
----------------------

The CodeQL library for Python also supplies classes to specify taint-tracking analyses. The ``Configuration`` class can be overridden to specify a taint-tracking analysis, by specifying source, sinks, sanitizers and additional flow steps. For those analyses that require additional types of taint to be tracked the ``TaintKind`` class can be overridden.


Summary
^^^^^^^

- `TaintKind <https://help.semmle.com/qldoc/python/semmle/python/dataflow/TaintTracking.qll/type.TaintTracking$TaintKind.html>`__
- `Configuration <https://help.semmle.com/qldoc/python/semmle/python/dataflow/Configuration.qll/type.Configuration$TaintTracking$Configuration.html>`__

For more information about these classes, see ":doc:`Analyzing data flow and tracking tainted data in Python <analyzing-data-flow-and-tracking-tainted-data-in-python>`."


Further reading
---------------

.. include:: ../../reusables/python-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst

