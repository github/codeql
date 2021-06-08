.. _using-api-graphs-in-python:

Using API graphs in Python
==========================

API graphs are a uniform interface for referring to functions, classes, and methods defined in
external libraries.

About this article
------------------

This article describes how to use API graphs to reference classes and functions defined in library
code. You can use API graphs to conveniently refer to external library functions when defining things like
remote flow sources.


Module imports
--------------

The most common entry point into the API graph will be the point where an external module or package is
imported. For example, you can access the API graph node corresponding to the ``re`` library
by using the ``API::moduleImport`` method defined in the ``semmle.python.ApiGraphs`` module, as the
following snippet demonstrates.

.. code-block:: ql

    import python
    import semmle.python.ApiGraphs

    select API::moduleImport("re")

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1876172022264324639/>`__.

This query selects the API graph node corresponding to the ``re`` module. This node represents the fact that the ``re`` module has been imported rather than a specific location in the program where the import happens. Therefore, there will be at most one result per project, and it will not have a useful location, so you'll have to click `Show 1 non-source result` in order to see it.

To find where the ``re`` module is referenced in the program, you can use the ``getAUse`` method. The following query selects all references to the ``re`` module in the current database.

.. code-block:: ql

    import python
    import semmle.python.ApiGraphs

    select API::moduleImport("re").getAUse()

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8072356519514905526/>`__.

Note that the ``getAUse`` method accounts for local flow, so that ``my_re_compile``
in the following snippet is
correctly recognized as a reference to the ``re.compile`` function.

.. code-block:: python

    from re import compile as re_compile

    my_re_compile = re_compile

    r = my_re_compile(".*")

If you only require immediate uses, without taking local flow into account, then you can use
the ``getAnImmediateUse`` method instead.

Note that the given module name *must not* contain any dots. Thus, something like
``API::moduleImport("flask.views")`` will not do what you expect. Instead, this should be decomposed
into an access of the ``views`` member of the API graph node for ``flask``, as described in the next
section.

Accessing attributes
--------------------

Given a node in the API graph, you can access its attributes by using the ``getMember`` method. Using
the above ``re.compile`` example, you can now find references to ``re.compile``.

.. code-block:: ql

    import python
    import semmle.python.ApiGraphs

    select API::moduleImport("re").getMember("compile").getAUse()

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/7970570434725297676/>`__.

In addition to ``getMember``, you can use the ``getUnknownMember`` method to find references to API
components where the name is not known statically. You can use the ``getAMember`` method to
access all members, both known and unknown.

Calls and class instantiations
------------------------------

To track instances of classes defined in external libraries, or the results of calling externally
defined functions, you can use the ``getReturn`` method. The following snippet finds all places
where the return value of ``re.compile`` is used:

.. code-block:: ql

    import python
    import semmle.python.ApiGraphs

    select API::moduleImport("re").getMember("compile").getReturn().getAUse()

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/4346050399960356921/>`__.

Note that this includes all uses of the result of ``re.compile``, including those reachable via
local flow. To get just the *calls* to ``re.compile``, you can use ``getAnImmediateUse`` instead of
``getAUse``. As this is a common occurrence, you can use ``getACall`` instead of
``getReturn`` followed by ``getAnImmediateUse``.

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8143347716552092926/>`__.

Note that the API graph does not distinguish between class instantiations and function calls. As far
as it's concerned, both are simply places where an API graph node is called.

Subclasses
----------

For many libraries, the main mode of usage is to extend one or more library classes. To track this
in the API graph, you can use the ``getASubclass`` method to get the API graph node corresponding to
all the immediate subclasses of this node. To find *all* subclasses, use ``*`` or ``+`` to apply the
method repeatedly, as in ``getASubclass*``.

Note that ``getASubclass`` does not account for any subclassing that takes place in library code
that has not been extracted. Thus, it may be necessary to account for this in the models you write.
For example, the ``flask.views.View`` class has a predefined subclass ``MethodView``. To find
all subclasses of ``View``, you must explicitly include the subclasses of ``MethodView`` as well.

.. code-block:: ql

    import python
    import semmle.python.ApiGraphs

    API::Node viewClass() {
      result =
        API::moduleImport("flask").getMember("views").getMember(["View", "MethodView"]).getASubclass*()
    }

    select viewClass().getAUse()

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/288293322319747121/>`__.

Note the use of the set literal ``["View", "MethodView"]`` to match both classes simultaneously.

Built-in functions and classes
------------------------------

You can access built-in functions and classes using the ``API::builtin`` method, giving the name of
the built-in as an argument.

For example, to find all calls to the built-in ``open`` function, you can use the following snippet.

.. code-block:: ql

    import python
    import semmle.python.ApiGraphs

    select API::builtin("open").getACall()




Further reading
---------------


.. include:: ../reusables/python-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
