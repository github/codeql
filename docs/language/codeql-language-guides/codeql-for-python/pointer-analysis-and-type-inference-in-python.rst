.. _pointer-analysis-and-type-inference-in-python:

Pointer analysis and type inference in Python
=============================================

At runtime, each Python expression has a value with an associated type. You can learn how an expression behaves at runtime by using type-inference classes from the standard CodeQL library.

The ``Value`` class
--------------------

The ``Value`` class and its subclasses ``FunctionValue``, ``ClassValue``, and ``ModuleValue`` represent the values an expression may hold at runtime.

Summary
^^^^^^^

Class hierarchy for ``Value``:

-  `Value <https://help.semmle.com/qldoc/python/semmle/python/objects/ObjectAPI.qll/type.ObjectAPI$Value.html>`__

   -  ``ClassValue``
   -  ``FunctionValue``
   -  ``ModuleValue``

Points-to analysis and type inference
-------------------------------------

Points-to analysis, sometimes known as pointer analysis, allows us to determine which objects an expression may "point to" at runtime. Type inference allows us to infer what the types (classes) of an expression may be at runtime. For more information, see `Pointer analysis <http://en.wikipedia.org/wiki/Pointer_analysis>`__ and `Type inference <http://en.wikipedia.org/wiki/Type_inference>`__ on Wikipedia.

The predicate ``ControlFlowNode.pointsTo(...)`` shows which object a control flow node may "point to" at runtime.

``ControlFlowNode.pointsTo(...)`` has three variants:

.. code-block:: ql

   predicate pointsTo(Value object)
   predicate pointsTo(Value object, ControlFlowNode origin)
   predicate pointsTo(Context context, Value object, ControlFlowNode origin)

``object`` is an object that the control flow node refers to, and ``origin`` is where the object comes from, which is useful for displaying meaningful results.

The third form includes the ``context`` in which the control flow node refers to the ``object``. This form can usually be ignored.

.. pull-quote::

   Note

   ``ControlFlowNode.pointsTo()`` cannot find all objects that a control flow node might point to as it is impossible to be accurate *and* to find all possible values. We prefer precision (no incorrect values) over recall (finding as many values as possible). We do this so that queries based on points-to analysis have fewer false positive results and are thus more useful.

For complex data flow analyses, involving multiple stages, the ``ControlFlowNode`` version is more precise, but for simple use cases the ``Expr`` based version is easier to use. For convenience, the ``Expr`` class also has the same three predicates. ``Expr.pointsTo(...)`` also has three variants:

.. code-block:: ql

   predicate pointsTo(Value object)
   predicate pointsTo(Value object, AstNode origin)
   predicate pointsTo(Context context, Value object, AstNode origin)

Using points-to analysis
------------------------

In this example we use points-to analysis to build a more complex query. This query is included in the standard query set.

We want to find ``except`` blocks in a ``try`` statement that are in the wrong order. That is, where a more general exception type precedes a more specific one, which is a problem as the second ``except`` handler will never be executed.

First we can write a query to find ordered pairs of ``except`` blocks for a ``try`` statement.

**Ordered except blocks in same** ``try`` **statement**

.. code-block:: ql

   import python

   from Try t, ExceptStmt ex1, ExceptStmt ex2
   where
   exists(int i, int j |
       ex1 = t.getHandler(i) and ex2 = t.getHandler(j) and i < j
   )
   select t, ex1, ex2

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/672320024/>`__. Many projects contain ordered ``except`` blocks in a ``try`` statement.

Here ``ex1`` and ``ex2`` are both ``except`` handlers in the ``try`` statement ``t``. By using the indices ``i`` and ``j`` we can also ensure that ``ex1`` precedes ``ex2``.

The results of this query need to be filtered to return only results where ``ex1`` is more general than ``ex2``. We can use the fact that an ``except`` block is more general than another block if the class it handles is a superclass of the other.

**More general** ``except`` **block**

.. code-block:: ql

   exists(ClassValue cls1, ClassValue cls2 |
       ex1.getType().pointsTo(cls1) and
       ex2.getType().pointsTo(cls2) |
       not cls1 = cls2 and
       cls1 = cls2.getASuperType()
   )

The line:

::

   ex1.getType().pointsTo(cls1)

ensures that ``cls1`` is a ``ClassValue`` that the ``except`` block would handle.

Combining the parts of the query we get this:

**More general** ``except`` **block precedes more specific**

.. code-block:: ql

   import python

   from Try t, ExceptStmt ex1, ExceptStmt ex2
   where
   exists(int i, int j |
       ex1 = t.getHandler(i) and ex2 = t.getHandler(j) and i < j
   )
   and
   exists(ClassValue cls1, ClassValue cls2 |
       ex1.getType().pointsTo(cls1) and
       ex2.getType().pointsTo(cls2) |
       not cls1 = cls2 and
       cls1 = cls2.getASuperType()
   )
   select t, ex1, ex2

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/669950027/>`__. This query finds only one result in the demo projects on LGTM.com (`youtube-dl <https://lgtm.com/projects/g/ytdl-org/youtube-dl/rev/39e9d524e5fe289936160d4c599a77f10f6e9061/files/devscripts/buildserver.py?sort=name&dir=ASC&mode=heatmap#L413>`__). The result is also highlighted by the standard "Unreachable 'except' block" query. For more information, see `Unreachable 'except' block <https://lgtm.com/rules/7900089>`__ on LGTM.com.

.. pull-quote::

   Note

   If you want to submit a query for use in LGTM, then the format must be of the form ``select`` ``element`` ``message``. For example, you might replace the ``select`` statement with: ``select t, "Incorrect order of except blocks; more general precedes more specific"``

Using type inference
--------------------

In this example we use type inference to determine when an object is used as a sequence in a ``for`` statement, but that object might not be an ``"iterable"``.

First of all find what object is used in the ``for`` loop:

.. code-block:: ql

   from For loop, Value iter
   where loop.getIter().pointsTo(iter)
   select loop, iter

Then we need to determine if the object ``iter`` is iterable. We can test ``ClassValue`` to see if it has the ``__iter__`` attribute.

**Find non-iterable object used as a loop iterator**

.. code-block:: ql

    import python

    from For loop, Value iter, ClassValue cls
    where loop.getIter().getAFlowNode().pointsTo(iter) and
      cls = iter.getClass() and
      not exists(cls.lookup("__iter__"))
    select loop, cls
    
➤ `See this in the query console on LGTM.com <https://lgtm.com/query/5636475906111506420/>`__. Many projects use a non-iterable as a loop iterator.

Many of the results shown will have ``cls`` as ``NoneType``. It is more informative to show where these ``None`` values may come from. To do this we use the final field of ``pointsTo``, as follows:

**Find non-iterable object used as a loop iterator 2**

.. code-block:: ql

   import python

   from For loop, Value iter, ClassValue cls, AstNode origin
   where loop.getIter().pointsTo(iter, origin) and
     cls = iter.getClass() and
     not cls.hasAttribute("__iter__")
   select loop, cls, origin

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/3795352249440053606/>`__. This reports the same results, but with a third column showing the source of the ``None`` values.

Finding calls using call-graph analysis
----------------------------------------------------

The ``Value`` class has a method ``getACall()`` which allows us to find calls to a particular function (including builtin functions).

If we wish to restrict the callables to actual functions we can use the ``FunctionValue`` class, which is a subclass of ``Value`` and corresponds to function objects in Python, in much the same way as the ``ClassValue`` class corresponds to class objects in Python.

Returning to an example from ":doc:`Functions in Python <functions-in-python>`," we wish to find calls to the ``eval`` function.

The original query looked this:

.. code-block:: ql

   import python

   from Call call, Name name
   where call.getFunc() = name and name.getId() = "eval"
   select call, "call to 'eval'."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/6718356557331218618/>`__. Some of the demo projects on LGTM.com have calls that match this pattern.

There are two problems with this query:

-  It assumes that any call to something named "eval" is a call to the builtin ``eval`` function, which may result in some false positive results.
-  It assumes that ``eval`` cannot be referred to by any other name, which may result in some false negative results.

We can get much more accurate results using call-graph analysis. First, we can precisely identify the ``FunctionValue`` for the ``eval`` function, by using the ``Value::named`` predicate as follows:

.. code-block:: ql

   import python

   from Value eval
   where eval = Value::named("eval")
   select eval

Then we can use ``Value.getACall()`` to identify calls to the ``eval`` function, as follows:

.. code-block:: ql

   import python

   from ControlFlowNode call, Value eval
   where eval = Value::named("eval") and
         call = eval.getACall()
   select call, "call to 'eval'."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/535131812579637425/>`__. This accurately identifies calls to the builtin ``eval`` function even when they are referred to using an alternative name. Any false positive results with calls to other ``eval`` functions, reported by the original query, have been eliminated.

Further reading
---------------

.. include:: ../../reusables/python-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst

