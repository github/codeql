.. _analyzing-data-flow-in-python:

Analyzing data flow in Python
=============================

You can use CodeQL to track the flow of data through a Python program to places where the data is used.

About this article
------------------

This article describes how data flow analysis is implemented in the CodeQL libraries for Python and includes examples to help you write your own data flow queries.
The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.
For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

Local data flow
---------------

Local data flow is data flow within a single method or callable. Local data flow is easier, faster, and more precise than global data flow, and is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

The local data flow library is in the module ``DataFlow``, which defines the class ``Node`` denoting any element that data can flow through. The ``Node`` class has a number of useful subclasses, such as ``ExprNode`` for expressions, ``CallCfgNode`` for function and method calls, and ``ParameterNode`` for parameters, all of which are subclasses of ``CfgNode`` which holds all those data-flow nodes which are associated with a control-flow node. You can map between data flow nodes and expressions/control-flow nodes using the member predicates ``asExpr`` and ``asCfgNode``:

.. code-block:: ql

     class Node {
       /** Gets the expression corresponding to this node, if any. */
       Expr asExpr() { ... }

       /** Gets the control-flow node corresponding to this node, if any. */
       ControlFlowNode asCfgNode() { ... }

      ...
     }

or using the predicate ``exprNode``:

.. code-block:: ql

     /**
      * Gets a node corresponding to expression `e`.
      */
     ExprNode exprNode(Expr e) { ... }

Due to the control-flow graph being split, there can be multiple data-flow nodes associated with a single expression.

The predicate ``localFlowStep(Node nodeFrom, Node nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``. You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localFlow``.

For example, you can find flow from a parameter ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     DataFlow::localFlow(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

.. code-block:: python

     temp = x
     y = temp + ", " + temp

If ``x`` is a tainted string then ``y`` is also tainted.

The local taint tracking library is in the module ``TaintTracking``. Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``. You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localTaint``.

For example, you can find taint propagation from a parameter ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     TaintTracking::localTaint(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Examples
~~~~~~~~

Python has builtin functionality for reading and writing files, such as the function ``open``. However, there is also the library ``os`` which provides low-level file access. This query finds the filename passed to ``os.open``:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call
    where
      call = API::moduleImport("os").getMember("open").getACall()
    select call.getArg(0)

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8635258505893505141/>`__. Two of the demo projects make use of this low-level API.

Unfortunately this will only give the expression in the argument, not the values which could be passed to it. So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ExprNode expr
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      DataFlow::localFlow(expr, call.getArg(0))
    select call, expr

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/8213643003890447109/>`__. Many expressions flow to the same call.

We see that we get several data-flow nodes for an expression as it flows towards a call (notice repeated locations in the ``call`` column). We are mostly interested in the "first" of these, what might be called the local source for the file name. To restrict attention to such local sources, and to simultaneously make the analysis more performant, we have the QL class ``LocalSourceNode``:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ExprNode expr
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      DataFlow::localFlow(expr, call.getArg(0)) and
      expr instanceof DataFlow::LocalSourceNode
    select call, expr

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2017139821928498055/>`__. We now mostly have one expression per call.

We still have some cases of more than one expression flowing to a call, but then they flow through different code paths (possibly due to control-flow splitting, as in the second case).

We can also make the source more specific, for example a parameter to a function or method. This query finds instances where a parameter is used as the name when opening a file:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ParameterNode p
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      DataFlow::localFlow(p, call.getArg(0))
    select call, p

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/3998032643497238063/>`__. Very few hits now; these could feasibly be inspected manually.

Using the exact name supplied via the parameter may be too strict. If we want to know if the parameter influences the file name, we can use taint tracking instead of data flow. This query finds calls to ``os.open`` where the filename is derived from a parameter:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.TaintTracking
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ParameterNode p
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      TaintTracking::localTaint(p, call.getArg(0))
    select call, p

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/2129957933670836953/>`__. Now we get more hits and in more projects.

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

The global data flow library is used by extending the class ``DataFlow::Configuration``:

.. code-block:: ql

   import python

   class MyDataFlowConfiguration extends DataFlow::Configuration {
     MyDataFlowConfiguration() { this = "..." }

     override predicate isSource(DataFlow::Node source) {
       ...
     }

     override predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

These predicates are defined in the configuration:

-  ``isSource`` - defines where data may flow from.
-  ``isSink`` - defines where data may flow to.
-  ``isBarrier`` - optionally, restricts the data flow.
-  ``isAdditionalFlowStep`` - optionally, adds additional flow steps.

The characteristic predicate (``MyDataFlowConfiguration()``) defines the name of the configuration, so ``"..."`` must be replaced with a unique name (for instance the class name).

The data flow analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from MyDataFlowConfiguation dataflow, DataFlow::Node source, DataFlow::Node sink
   where dataflow.hasFlow(source, sink)
   select source, "Dataflow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow what local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. The global taint tracking library is used by extending the class ``TaintTracking::Configuration``:

.. code-block:: ql

   import python

   class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
     MyTaintTrackingConfiguration() { this = "..." }

     override predicate isSource(DataFlow::Node source) {
       ...
     }

     override predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

These predicates are defined in the configuration:

-  ``isSource`` - defines where taint may flow from.
-  ``isSink`` - defines where taint may flow to.
-  ``isSanitizer`` - optionally, restricts the taint flow.
-  ``isAdditionalTaintStep`` - optionally, adds additional taint steps.

Similar to global data flow, the characteristic predicate (``MyTaintTrackingConfiguration()``) defines the unique name of the configuration and the taint analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``.

Flow sources
~~~~~~~~~~~~

The data flow library contains some predefined flow sources. The class ``RemoteFlowSource`` (defined in module ``semmle.python.dataflow.new.RemoteFlowSources``) represents data flow from remote network inputs. This is useful for finding security problems in networked services.

Example
~~~~~~~

This query shows a data flow configuration that uses all network input as data sources:

.. code-block:: ql

   import python
   import semmle.code.csharp.dataflow.flowsources.PublicCallableParameter

   class MyDataFlowConfiguration extends DataFlow::Configuration {
     MyDataFlowConfiguration() {
       this = "..."
     }

     override predicate isSource(DataFlow::Node source) {
       source instanceof RemoteFlowSource
     }

     ...
   }

Class hierarchy
~~~~~~~~~~~~~~~

-  ``DataFlow::Configuration`` - base class for custom global data flow analysis.
-  ``DataFlow::Node`` - an element behaving as a data flow node.

   -  ``DataFlow::ExprNode`` - an expression behaving as a data flow node.
   -  ``DataFlow::ParameterNode`` - a parameter data flow node representing the value of a parameter at function entry.
   -  ``RemoteFlowSource`` - data flow from network/remote input.

-  ``TaintTracking::Configuration`` - base class for custom global taint tracking analysis.

Examples
~~~~~~~~

This data flow configuration tracks data flow from environment variables to opening files:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.TaintTracking
    import semmle.python.ApiGraphs

    class EnvironmentToFileConfiguration extends DataFlow::Configuration {
      EnvironmentToFileConfiguration() { this = "EnvironmentToFileConfiguration" }

      override predicate isSource(DataFlow::Node source) {
        source = API::moduleImport("os").getMember("getenv").getACall()
      }

      override predicate isSink(DataFlow::Node sink) {
        exists(DataFlow::CallCfgNode call |
          call = API::moduleImport("os").getMember("open").getACall() and
          sink = call.getArg(0)
        )
      }
    }

    from Expr environment, Expr fileOpen, EnvironmentToFileConfiguration config
    where config.hasFlow(DataFlow::exprNode(environment), DataFlow::exprNode(fileOpen))
    select fileOpen, "This call to 'os.open' uses data from $@.",
      environment, "call to 'os.getenv'"

➤ `Running this in the query console on LGTM.com <https://lgtm.com/query/6582374907796191895/>`__ unsurprisingly yields no results in the demo projects.


Further reading
---------------

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"


.. include:: ../reusables/python-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
