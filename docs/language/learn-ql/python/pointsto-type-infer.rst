Tutorial: Points-to analysis and type inference
===============================================

This topic contains worked examples of how to write queries using the standard QL library classes for Python type inference.

The ``Object`` class
--------------------

The ``Object`` class and its subclasses ``FunctionObject``, ``ClassObject`` and ``ModuleObject`` represent the values an expression may hold at runtime.

Summary
~~~~~~~

Class hierarchy for ``Object``:

-  `Object <https://help.semmle.com/qldoc/python/semmle/python/types/Object.qll/type.Object$Object.html>`__

   -  ``ClassObject``
   -  ``FunctionObject``
   -  ``ModuleObject``

Points-to analysis and type inference
-------------------------------------

Points-to analysis, sometimes known as `pointer analysis <http://en.wikipedia.org/wiki/Pointer_analysis>`__, allows us to determine which objects an expression may "point to" at runtime.

`Type inference <http://en.wikipedia.org/wiki/Type_inference>`__ allows us to infer what the types (classes) of an expression may be at runtime.

The predicate ``ControlFlowNode.refersTo(...)`` shows which object a control flow node may "refer to" at runtime.

``ControlFlowNode.refersTo(...)`` has three variants:

.. code-block:: ql

   predicate refersTo(Object object)
   predicate refersTo(Object object, ControlFlowNode origin)
   predicate refersTo(Object object, ClassObject cls, ControlFlowNode origin)

``object`` is an object that the control flow node refers to, ``origin`` is where the object comes from, which is useful for displaying meaningful results, and ``cls`` is the inferred class of the ``object``.

.. pull-quote::

   Note

   ``ControlFlowNode.refersTo()`` cannot find all objects that a control flow node might point to as it impossible to be accurate and find all possible values. We prefer precision (no incorrect values) over recall (finding as many values as possible). We do this because queries based on points-to analysis have fewer false positives and are thus more useful.

For complex data flow analyses, involving multiple stages, the ``ControlFlowNode`` version is more precise, but for simple use cases the ``Expr`` based version is easier to use. For convenience, the ``Expr`` class also has the same three predicates. ``Expr.refersTo(...)`` also has three variants:

.. code-block:: ql

   predicate refersTo(Object object)
   predicate refersTo(Object object, AstNode origin)
   predicate refersTo(Object object, ClassObject cls, AstNode origin)

Using points-to analysis
------------------------

In this example we use points-to analysis to build a more complex query. This query is included in the standard query set.

We want to find ``except`` blocks in a ``try`` statement that are in the wrong order. That is, where a more general exception type precedes a more specific one, which is a problem as the second ``except`` handler will never be executed.

First we can write a query to find ordered pairs of ``except`` blocks for a ``try`` statement.

**Ordered except blocks in same ``try`` statement**

.. code-block:: ql

   import python

   from Try t, ExceptStmt ex1, ExceptStmt ex2
   where
   exists(int i, int j |
       ex1 = t.getHandler(i) and ex2 = t.getHandler(j) and i < j
   )
   select t, ex1, ex2

➤ `See this in the query console <https://lgtm.com/query/672320024/>`__. Many projects contain ordered ``except`` blocks in a ``try`` statement.

Here ``ex1`` and ``ex2`` are both ``except`` handlers in the ``try`` statement ``t``. By using the indices ``i`` and ``j`` we can also ensure that ``ex1`` precedes ``ex2``.

The results of this query need to be filtered to return only results where ``ex1`` is more general than ``ex2``. We can use the fact that an ``except`` block is more general than another block if the class it handles is a superclass of the other.

**More general ``except`` block**

.. code-block:: ql

   exists(ClassObject cls1, ClassObject cls2 |
       ex1.getType().refersTo(cls1) and
       ex2.getType().refersTo(cls2) |
       cls1 = cls2.getASuperType()
   )

The line:

::

   ex1.getType().refersTo(cls1)

ensures that ``cls1`` is a ``ClassObject`` that the ``except`` block would handle.

Combining the parts of the query we get this:

**More general ``except`` block precedes more specific**

.. code-block:: ql

   import python

   from Try t, ExceptStmt ex1, ExceptStmt ex2
   where
   exists(int i, int j |
       ex1 = t.getHandler(i) and ex2 = t.getHandler(j) and i < j
   )
   and
   exists(ClassObject cls1, ClassObject cls2 |
       ex1.getType().refersTo(cls1) and
       ex2.getType().refersTo(cls2) |
       cls1 = cls2.getASuperType()
   )
   select t, ex1, ex2

➤ `See this in the query console <https://lgtm.com/query/669950027/>`__. This query finds only one result in the demo projects on LGTM.com (`youtube-dl <https://lgtm.com/projects/g/ytdl-org/youtube-dl/rev/39e9d524e5fe289936160d4c599a77f10f6e9061/files/devscripts/buildserver.py?sort=name&dir=ASC&mode=heatmap#L413>`__). The result is also highlighted by the standard query: `Unreachable 'except' block <https://lgtm.com/rules/7900089>`__.

.. pull-quote::

   Note

   If you want to submit a query for use in LGTM, then the format must be of the form ``select`` ``element`` ``message``. For example, you might replace the ``select`` statement with: ``select t, "Incorrect order of except blocks; more general precedes more specific"``

Using type inference
--------------------

In this example we use type inference to determine when an object is used as a sequence in a ``for`` statement, but that object might not be an ``"iterable"``.

First of all find what object is used in the ``for`` loop:

.. code-block:: ql

   from For loop, Object iter
   where loop.getIter().refersTo(iter)
   select loop, iter

Then we need to determine if a ``ClassObject`` is iterable. ``ClassObject`` provides the predicate ``isIterable()`` which we can combine with the longer form of ``ControlFlowNode.refersTo()`` to get the class of the loop iterator, giving us this:

**Find non-iterable object used as a loop iterator**

.. code-block:: ql

   import python

   from For loop, Object iter, ClassObject cls
   where loop.getIter().refersTo(iter, cls, _)
     and not cls.isIterable()
   select loop, cls

➤ `See this in the query console <https://lgtm.com/query/670720182/>`__. Many projects use a non-iterable as a loop iterator.

Many of the results shown will have ``cls`` as ``NoneType``. It is more informative to show where these ``None`` values may come from. To do this we use the final field of ``refersTo``, as follows:

**Find non-iterable object used as a loop iterator 2**

.. code-block:: ql

   import python

   from For loop, Object iter, ClassObject cls, AstNode origin
   where loop.getIter().refersTo(iter, cls, origin)
     and not cls.isIterable()
   select loop, cls, origin

➤ `See this in the query console <https://lgtm.com/query/672230046/>`__. This reports the same results, but with a third column showing the source of the ``None`` values.

Finding calls to functions using call-graph analysis
----------------------------------------------------

The ``FunctionObject`` class is a subclass of ``Object`` and corresponds to function objects in Python, in much the same way as the ``ClassObject`` class corresponds to class objects in Python.

The ``FunctionObject`` class has a method ``getACall()`` which allows us to find calls to a particular function (including builtin functions).

Returning to an example from :doc:`Tutorial: Functions <functions>`, we wish to find calls to the ``input`` function.

The original query looked this:

.. code-block:: ql

   import python

   from Call call, Name name
   where call.getFunc() = name and name.getId() = "input"
   select call, "call to 'input'."

➤ `See this in the query console <https://lgtm.com/query/690010037/>`__. Two of the demo projects on LGTM.com have calls that match this pattern.

There are two problems with this query:

-  It assumes that any call to something named "input" is a call to the builtin ``input`` function, which may result in some false positive results.
-  It assumes that ``input`` cannot be referred to by any other name, which may result in some false negative results.

We can get much more accurate results using call-graph analysis. First, we can precisely identify the ``FunctionObject`` for the ``input`` function, by using the ``builtin_object`` QL predicate as follows:

.. code-block:: ql

   import python

   from FunctionObject input
   where input = builtin_object("input")
   select input

Then we can use ``FunctionObject.getACall()`` to identify calls to the ``input`` function, as follows:

.. code-block:: ql

   import python

   from ControlFlowNode call, FunctionObject input
   where input = builtin_object("input") and
         call = input.getACall()
   select call, "call to 'input'."

➤ `See this in the query console <https://lgtm.com/query/670490037/>`__. This accurately identifies calls to the builtin ``input`` function even when they are referred to using an alternative name. Any false positive results with calls to other ``input`` functions, reported by the original query, have been eliminated. It finds one result in files referenced by the *saltstack/salt* project.

What next?
----------

For more information on writing QL, see:

-  `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ - an introduction to the concepts of QL.
-  :doc:`Learning QL <../../index>` - an overview of the resources for learning how to write your own QL queries.
-  `Database generation <https://lgtm.com/help/lgtm/generate-database>`__ - an overview of the process that creates a snapshot from source code.
-  :doc:`What's in a snapshot? <../snapshot>` - a description of the snapshot database.
