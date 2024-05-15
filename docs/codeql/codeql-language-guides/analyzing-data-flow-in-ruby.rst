.. _analyzing-data-flow-in-ruby:

Analyzing data flow in Ruby
=============================

You can use CodeQL to track the flow of data through a Ruby program to places where the data is used.

About this article
------------------

This article describes how data flow analysis is implemented in the CodeQL libraries for Ruby and includes examples to help you write your own data flow queries.
The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.
For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

.. include:: ../reusables/new-data-flow-api.rst

Local data flow
---------------

Local data flow tracks the flow of data within a single method or callable. Local data flow is easier, faster, and more precise than global data flow. Before looking at more complex tracking, you should always consider local tracking because it is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

You can use the local data flow library by importing the ``DataFlow`` module. The library uses the class ``Node`` to represent any element through which data can flow.
``Node``\ s are divided into expression nodes (``ExprNode``) and parameter nodes (``ParameterNode``).
You can map a data flow ``ParameterNode`` to its corresponding ``Parameter`` AST node using the ``asParameter`` member predicate.
Similarly, you can use the ``asExpr`` member predicate to map a data flow ``ExprNode`` to its corresponding ``ExprCfgNode`` in the control-flow library.

.. code-block:: ql

     class Node {
       /** Gets the expression corresponding to this node, if any. */
       CfgNodes::ExprCfgNode asExpr() { ... }

       /** Gets the parameter corresponding to this node, if any. */
       Parameter asParameter() { ... }

      ...
     }

You can use the predicates ``exprNode`` and ``parameterNode`` to map from expressions and parameters to their data-flow node:

.. code-block:: ql

     /**
      * Gets a node corresponding to expression `e`.
      */
     ExprNode exprNode(CfgNodes::ExprCfgNode e) { ... }

     /**
      * Gets the node corresponding to the value of parameter `p` at function entry.
      */
     ParameterNode parameterNode(Parameter p) { ... }

Note that since ``asExpr`` and ``exprNode`` map between data-flow and control-flow nodes, you then need to call the ``getExpr`` member predicate on the control-flow node to map to the corresponding AST node,
for example, by writing ``node.asExpr().getExpr()``.
A control-flow graph considers every way control can flow through code, consequently, there can be multiple data-flow and control-flow nodes associated with a single expression node in the AST.

The predicate ``localFlowStep(Node nodeFrom, Node nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``.
You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localFlow``.

For example, you can find flow from an expression ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     DataFlow::localFlow(source, sink)

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow to include flow steps where values are not preserved, for example, string manipulation.
For example:

.. code-block:: ruby

     temp = x
     y = temp + ", " + temp

If ``x`` is a tainted string then ``y`` is also tainted.

The local taint tracking library is in the module ``TaintTracking``.
Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``.
You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localTaint``.

For example, you can find taint propagation from an expression ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     TaintTracking::localTaint(source, sink)


Using local sources
~~~~~~~~~~~~~~~~~~~

When exploring local data flow or taint propagation between two expressions as above, you would normally constrain the expressions to be relevant to your investigation.
The next section gives some concrete examples, but first it's helpful to introduce the concept of a local source.

A local source is a data-flow node with no local data flow into it.
As such, it is a local origin of data flow, a place where a new value is created.
This includes parameters (which only receive values from global data flow) and most expressions (because they are not value-preserving).
The class ``LocalSourceNode`` represents data-flow nodes that are also local sources.
It comes with a useful member predicate ``flowsTo(DataFlow::Node node)``, which holds if there is local data flow from the local source to ``node``.

Examples of local data flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This query finds the filename argument passed in each call to ``File.open``:

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call
    where call = API::getTopLevelMember("File").getAMethodCall("open")
    select call.getArgument(0)

Notice the use of the ``API`` module for referring to library methods.
For more information, see ":doc:`Using API graphs in Ruby <using-api-graphs-in-ruby>`."

Unfortunately this will only give the expression in the argument, not the values which could be passed to it.
So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call, DataFlow::ExprNode expr
    where
      call = API::getTopLevelMember("File").getAMethodCall("open") and
      DataFlow::localFlow(expr, call.getArgument(0))
    select call, expr

Many expressions flow to the same call.
If you run this query, you may notice that you get several data-flow nodes for an expression as it flows towards a call (notice repeated locations in the ``call`` column).
We are mostly interested in the "first" of these, what might be called the local source for the file name.
To restrict the results to local sources for the file name, and to simultaneously make the analysis more efficient, we can use the CodeQL class ``LocalSourceNode``.
We can update the query to specify that ``expr`` is an instance of a ``LocalSourceNode``.

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call, DataFlow::ExprNode expr
    where
      call = API::getTopLevelMember("File").getAMethodCall("open") and
      DataFlow::localFlow(expr, call.getArgument(0)) and
      expr instanceof DataFlow::LocalSourceNode
    select call, expr

An alternative approach to limit the results to local sources for the file name is to enforce this by casting.
That would allow us to use the member predicate ``flowsTo`` on ``LocalSourceNode`` like so:

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call, DataFlow::ExprNode expr
    where
      call = API::getTopLevelMember("File").getAMethodCall("open") and
      expr.(DataFlow::LocalSourceNode).flowsTo(call.getArgument(0))
    select call, expr

As an alternative, we can ask more directly that ``expr`` is a local source of the first argument, via the predicate ``getALocalSource``:

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call, DataFlow::ExprNode expr
    where
      call = API::getTopLevelMember("File").getAMethodCall("open") and
      expr = call.getArgument(0).getALocalSource()
    select call, expr

All these three queries give identical results.
We now mostly have one expression per call.

We may still have cases of more than one expression flowing to a call, but then they flow through different code paths (possibly due to control-flow splitting).

We might want to make the source more specific, for example, a parameter to a method or block.
This query finds instances where a parameter is used as the name when opening a file:

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call, DataFlow::ParameterNode p
    where
      call = API::getTopLevelMember("File").getAMethodCall("open") and
      DataFlow::localFlow(p, call.getArgument(0))
    select call, p

Using the exact name supplied via the parameter may be too strict.
If we want to know if the parameter influences the file name, we can use taint tracking instead of data flow.
This query finds calls to ``File.open`` where the file name is derived from a parameter:

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.TaintTracking
    import codeql.ruby.ApiGraphs

    from DataFlow::CallNode call, DataFlow::ParameterNode p
    where
      call = API::getTopLevelMember("File").getAMethodCall("open") and
      TaintTracking::localTaint(p, call.getArgument(0))
    select call, p

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow.
However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

You can use the global data flow library by implementing the signature ``DataFlow::ConfigSig`` and applying the module ``DataFlow::Global<ConfigSig>``:

.. code-block:: ql

   import codeql.ruby.DataFlow

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

Global taint tracking is to global data flow what local taint tracking is to local data flow.
That is, global taint tracking extends global data flow with additional non-value-preserving steps.
The global taint tracking library is used by applying the module ``TaintTracking::Global<ConfigSig>`` to your configuration instead of ``DataFlow::Global<ConfigSig>``:

.. code-block:: ql

   import codeql.ruby.DataFlow
   import codeql.ruby.TaintTracking

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

-  The class ``RemoteFlowSource`` (defined in module ``codeql.ruby.dataflow.RemoteFlowSources``) represents data flow from remote network inputs. This is useful for finding security problems in networked services.
-  The library ``Concepts`` (defined in module ``codeql.ruby.Concepts``) contains several subclasses of ``DataFlow::Node`` that are security relevant, such as ``FileSystemAccess`` and ``SqlExecution``.

For global flow, it is also useful to restrict sources to instances of ``LocalSourceNode``.
The predefined sources generally do that.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``DataFlow::Node`` - an element behaving as a data-flow node.
    -  ``DataFlow::LocalSourceNode`` - a local origin of data, as a data-flow node.
    -  ``DataFlow::ExprNode`` - an expression behaving as a data-flow node.
    -  ``DataFlow::ParameterNode`` - a parameter data-flow node representing the value of a parameter at method/block entry.

    -  ``RemoteFlowSource`` - data flow from network/remote input.
    -  ``Concepts::SystemCommandExecution`` - a data-flow node that executes an operating system command, for instance by spawning a new process.
    -  ``Concepts::FileSystemAccess`` - a data-flow node that performs a file system access, including reading and writing data, creating and deleting files and folders, checking and updating permissions, and so on.
    -  ``Concepts::Path::PathNormalization`` - a data-flow node that performs path normalization. This is often needed in order to safely access paths.
    -  ``Concepts::CodeExecution`` - a data-flow node that dynamically executes Ruby code.
    -  ``Concepts::SqlExecution`` - a data-flow node that executes SQL statements.
    -  ``Concepts::HTTP::Server::RouteSetup`` - a data-flow node that sets up a route on a server.
    -  ``Concepts::HTTP::Server::HttpResponse`` - a data-flow node that creates an HTTP response on a server.

Examples of global data flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following global taint-tracking query finds path arguments in filesystem accesses that can be controlled by a remote user.
  - Since this is a taint-tracking query, the ``TaintTracking::Global<ConfigSig>`` module is used.
  - The ``isSource`` predicate defines sources as any data-flow nodes that are instances of ``RemoteFlowSource``.
  - The ``isSink`` predicate defines sinks as path arguments in any filesystem access, using ``FileSystemAccess`` from the ``Concepts`` library.

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.TaintTracking
    import codeql.ruby.Concepts
    import codeql.ruby.dataflow.RemoteFlowSources

    module RemoteToFileConfiguration implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

      predicate isSink(DataFlow::Node sink) {
        sink = any(FileSystemAccess fa).getAPathArgument()
      }
    }

    module RemoteToFileFlow = TaintTracking::Global<RemoteToFileConfiguration>;

    from DataFlow::Node input, DataFlow::Node fileAccess
    where RemoteToFileFlow::flow(input, fileAccess)
    select fileAccess, "This file access uses data from $@.", input, "user-controllable input."

The following global data-flow query finds calls to ``File.open`` where the filename argument comes from an environment variable.
  - Since this is a data-flow query, the ``DataFlow::Global<ConfigSig>`` module is used.
  - The ``isSource`` predicate defines sources as expression nodes representing lookups on the ``ENV`` hash.
  - The ``isSink`` predicate defines sinks as the first argument in any call to ``File.open``.

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.controlflow.CfgNodes
    import codeql.ruby.ApiGraphs

    module EnvironmentToFileConfiguration implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node source) {
        exists(ExprNodes::ConstantReadAccessCfgNode env |
          env.getExpr().getName() = "ENV" and
          env = source.asExpr().(ExprNodes::ElementReferenceCfgNode).getReceiver()
        )
      }

      predicate isSink(DataFlow::Node sink) {
        sink = API::getTopLevelMember("File").getAMethodCall("open").getArgument(0)
      }
    }

    module EnvironmentToFileFlow = DataFlow::Global<EnvironmentToFileConfiguration>;

    from DataFlow::Node environment, DataFlow::Node fileOpen
    where EnvironmentToFileFlow::flow(environment, fileOpen)
    select fileOpen, "This call to 'File.open' uses data from $@.", environment,
      "an environment variable"

Further reading
---------------

- `Exploring data flow with path queries  <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/exploring-data-flow-with-path-queries>`__ in the GitHub documentation.


.. include:: ../reusables/ruby-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
