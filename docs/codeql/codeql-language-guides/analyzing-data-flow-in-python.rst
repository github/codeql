.. _analyzing-data-flow-in-python:

Analyzing data flow in Python
=============================

You can use CodeQL to track the flow of data through a Python program to places where the data is used.

About this article
------------------

This article describes how data flow analysis is implemented in the CodeQL libraries for Python and includes examples to help you write your own data flow queries.
The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.
For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

.. include:: ../reusables/new-data-flow-api.rst

Local data flow
---------------

Local data flow is data flow within a single method or callable. Local data flow is easier, faster, and more precise than global data flow, and is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

The local data flow library is in the module ``DataFlow``, which defines the class ``Node`` denoting any element that data can flow through. The ``Node`` class has a number of useful subclasses, such as ``ExprNode`` for expressions, ``CfgNode`` for control-flow nodes, ``CallCfgNode`` for function and method calls, and ``ParameterNode`` for parameters. You can map between data flow nodes and expressions/control-flow nodes using the member predicates ``asExpr`` and ``asCfgNode``:

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

For example, you can find flow from an expression ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     DataFlow::localFlow(DataFlow::exprNode(source), DataFlow::exprNode(sink))

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

.. code-block:: python

     temp = x
     y = temp + ", " + temp

If ``x`` is a tainted string then ``y`` is also tainted.

The local taint tracking library is in the module ``TaintTracking``. Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``. You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localTaint``.

For example, you can find taint propagation from an expression ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     TaintTracking::localTaint(DataFlow::exprNode(source), DataFlow::exprNode(sink))


Using local sources
~~~~~~~~~~~~~~~~~~~

When asking for local data flow or taint propagation between two expressions as above, you would normally constrain the expressions to be relevant to a certain investigation. The next section will give some concrete examples, but there is a more abstract concept that we should call out explicitly, namely that of a local source.

A local source is a data-flow node with no local data flow into it. As such, it is a local origin of data flow, a place where a new value is created. This includes parameters (which only receive global data flow) and most expressions (because they are not value-preserving). Restricting attention to such local sources gives a much lighter and more performant data-flow graph and in most cases also a more suitable abstraction for the investigation of interest. The class ``LocalSourceNode`` represents data-flow nodes that are also local sources. It comes with a useful member predicate ``flowsTo(DataFlow::Node node)``, which holds if there is local data flow from the local source to ``node``.

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

Notice the use of the ``API`` module for referring to library functions. For more information, see ":doc:`Using API graphs in Python <using-api-graphs-in-python>`."

Unfortunately this query will only give the expression in the argument, not the values which could be passed to it. So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ExprNode expr
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      DataFlow::localFlow(expr, call.getArg(0))
    select call, expr

Typically, you will see several data-flow nodes for an expression as it flows towards a call (notice repeated locations in the ``call`` column). We are mostly interested in the "first" of these, what might be called the local source for the file name. To restrict attention to such local sources, and to simultaneously make the analysis more performant, we have the QL class ``LocalSourceNode``. We could demand that ``expr`` is such a node:

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

However, we could also enforce this by casting. That would allow us to use the member function ``flowsTo`` on ``LocalSourceNode`` like so:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ExprNode expr
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      expr.(DataFlow::LocalSourceNode).flowsTo(call.getArg(0))
    select call, expr

As an alternative, we can ask more directly that ``expr`` is a local source of the first argument, via the predicate ``getALocalSource``:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ExprNode expr
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      expr = call.getArg(0).getALocalSource()
    select call, expr

These three queries all give identical results. We now mostly have one expression per call.

We still have some cases of more than one expression flowing to a call, but then they flow through different code paths (possibly due to control-flow splitting).

We might want to make the source more specific, for example a parameter to a function or method. This query finds instances where a parameter is used as the name when opening a file:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.ApiGraphs

    from DataFlow::CallCfgNode call, DataFlow::ParameterNode p
    where
      call = API::moduleImport("os").getMember("open").getACall() and
      DataFlow::localFlow(p, call.getArg(0))
    select call, p

For most codebases, this will return only a few results and these could be inspected manually.

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

Typically, this finds more results.

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

The global data flow library is used by implementing the signature ``DataFlow::ConfigSig`` and applying the module ``DataFlow::Global<ConfigSig>``:

.. code-block:: ql

   import python

   module MyFlowConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       ...
     }

     predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

   module MyFlow = DataFlow::Global<MyFlowConfiguration>;

These predicates are defined in the configuration:

-  ``isSource`` - defines where data may flow from.
-  ``isSink`` - defines where data may flow to.
-  ``isBarrier`` - optionally, restricts the data flow.
-  ``isAdditionalFlowStep`` - optionally, adds additional flow steps.

The data flow analysis is performed using the predicate ``flow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from DataFlow::Node source, DataFlow::Node sink
   where MyFlow::flow(source, sink)
   select source, "Dataflow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow what local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. The global taint tracking library is used by applying the module ``TaintTracking::Global<ConfigSig>`` to your configuration instead of ``DataFlow::Global<ConfigSig>``:

.. code-block:: ql

   import python

   module MyFlowConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       ...
     }

     predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

   module MyFlow = TaintTracking::Global<MyFlowConfiguration>;

The resulting module has an identical signature to the one obtained from ``DataFlow::Global<ConfigSig>``.

Predefined sources and sinks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data flow library contains a number of predefined sources and sinks, providing a good starting point for defining data flow based security queries.

-  The class ``RemoteFlowSource`` (defined in module ``semmle.python.dataflow.new.RemoteFlowSources``) represents data flow from remote network inputs. This is useful for finding security problems in networked services.
-  The library ``Concepts`` (defined in module ``semmle.python.Concepts``) contain several subclasses of ``DataFlow::Node`` that are security relevant, such as ``FileSystemAccess`` and ``SqlExecution``.
-  The module ``Attributes`` (defined in module ``semmle.python.dataflow.new.internal.Attributes``) defines ``AttrRead`` and ``AttrWrite`` which handle both ordinary and dynamic attribute access.

For global flow, it is also useful to restrict sources to instances of ``LocalSourceNode``. The predefined sources generally do that.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``DataFlow::Node`` - an element behaving as a data flow node.

    -  ``DataFlow::CfgNode`` - a control-flow node behaving as a data flow node.

        -  ``DataFlow::ExprNode`` - an expression behaving as a data flow node.
        -  ``DataFlow::ParameterNode`` - a parameter data flow node representing the value of a parameter at function entry.
        -  ``DataFlow::CallCfgNode`` - a control-flow node for a function or method call behaving as a data flow node.

    -  ``RemoteFlowSource`` - data flow from network/remote input.
    -  ``Attributes::AttrRead`` - an attribute read as a data flow node.
    -  ``Attributes::AttrWrite`` - an attribute write as a data flow node.
    -  ``Concepts::SystemCommandExecution`` - a data-flow node that executes an operating system command, for instance by spawning a new process.
    -  ``Concepts::FileSystemAccess`` - a data flow node that performs a file system access, including reading and writing data, creating and deleting files and folders, checking and updating permissions, and so on.
    -  ``Concepts::Path::PathNormalization`` - a data-flow node that performs path normalization. This is often needed in order to safely access paths.
    -  ``Concepts::Decoding`` - a data-flow node that decodes data from a binary or textual format. A decoding (automatically) preserves taint from input to output. However, it can also be a problem in itself, for example if it allows code execution or could result in denial-of-service.
    -  ``Concepts::Encoding`` - a data-flow node that encodes data to a binary or textual format. An encoding (automatically) preserves taint from input to output.
    -  ``Concepts::CodeExecution`` - a data-flow node that dynamically executes Python code.
    -  ``Concepts::SqlExecution`` - a data-flow node that executes SQL statements.
    -  ``Concepts::HTTP::Server::RouteSetup`` - a data-flow node that sets up a route on a server.
    -  ``Concepts::HTTP::Server::HttpResponse`` - a data-flow node that creates a HTTP response on a server.

Examples
~~~~~~~~

This query shows a data flow configuration that uses all network input as data sources:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.DataFlow
    import semmle.python.dataflow.new.TaintTracking
    import semmle.python.dataflow.new.RemoteFlowSources
    import semmle.python.Concepts

    module RemoteToFileConfiguration implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node source) {
        source instanceof RemoteFlowSource
      }

      predicate isSink(DataFlow::Node sink) {
        sink = any(FileSystemAccess fa).getAPathArgument()
      }
    }

    module RemoteToFileFlow = TaintTracking::Global<RemoteToFileConfiguration>;

    from DataFlow::Node input, DataFlow::Node fileAccess
    where RemoteToFileFlow::flow(input, fileAccess)
    select fileAccess, "This file access uses data from $@.",
      input, "user-controllable input."

This data flow configuration tracks data flow from environment variables to opening files:

.. code-block:: ql

    import python
    import semmle.python.dataflow.new.TaintTracking
    import semmle.python.ApiGraphs

    module EnvironmentToFileConfiguration implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node source) {
        source = API::moduleImport("os").getMember("getenv").getACall()
      }

      predicate isSink(DataFlow::Node sink) {
        exists(DataFlow::CallCfgNode call |
          call = API::moduleImport("os").getMember("open").getACall() and
          sink = call.getArg(0)
        )
      }
    }

    module EnvironmentToFileFlow = DataFlow::Global<EnvironmentToFileConfiguration>;

    from Expr environment, Expr fileOpen
    where EnvironmentToFileFlow::flow(DataFlow::exprNode(environment), DataFlow::exprNode(fileOpen))
    select fileOpen, "This call to 'os.open' uses data from $@.",
      environment, "call to 'os.getenv'"


Further reading
---------------

- `Exploring data flow with path queries  <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/exploring-data-flow-with-path-queries>`__ in the GitHub documentation.


.. include:: ../reusables/python-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
