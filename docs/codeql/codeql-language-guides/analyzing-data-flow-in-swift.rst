.. _analyzing-data-flow-in-swift:

Analyzing data flow in Swift
============================

You can use CodeQL to track the flow of data through a Swift program to places where the data is used.

About this article
------------------

This article describes how data flow analysis is implemented in the CodeQL libraries for Swift and includes examples to help you write your own data flow queries.
The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.
For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

Local data flow
---------------

Local data flow tracks the flow of data within a single function. Local data flow is easier, faster, and more precise than global data flow. Before looking at more complex tracking, you should always consider local tracking because it is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

You can use the local data flow library by importing the ``DataFlow`` module. The library uses the class ``Node`` to represent any element through which data can flow.
The ``Node`` class has a number of useful subclasses, such as ``ExprNode`` for expressions and ``ParameterNode`` for parameters. You can map between data flow nodes and expressions/control-flow nodes using the member predicates ``asExpr`` and ``getCfgNode``:

.. code-block:: ql

     class Node {
       /**
        * Gets the expression that corresponds to this node, if any.
        */
       Expr asExpr() { ... }

       /**
        * Gets the control flow node that corresponds to this data flow node.
        */
       ControlFlowNode getCfgNode() { ... }

       ...
     }

You can use the predicates ``exprNode`` and ``parameterNode`` to map from expressions and parameters to their data-flow node:

.. code-block:: ql

     /**
      * Gets a node corresponding to expression `e`.
      */
     ExprNode exprNode(DataFlowExpr e) { result.asExpr() = e }

     /**
      * Gets the node corresponding to the value of parameter `p` at function entry.
      */
     ParameterNode parameterNode(DataFlowParameter p) { result.getParameter() = p }

There can be multiple data-flow nodes associated with a single expression node in the AST.

The predicate ``localFlowStep(Node nodeFrom, Node nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``.
You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localFlow``.

For example, you can find flow from an expression ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     DataFlow::localFlow(DataFlow::exprNode(source), DataFlow::exprNode(sink))

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow to include flow steps where values are not preserved, such as string manipulation.
For example:

.. code-block:: swift

     temp = x
     y = temp + ", " + temp

If ``x`` is a tainted string then ``y`` is also tainted.

The local taint tracking library is in the module ``TaintTracking``.
Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``.
You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localTaint``.

For example, you can find taint propagation from an expression ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     TaintTracking::localTaint(DataFlow::exprNode(source), DataFlow::exprNode(sink))

Examples of local data flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This query finds the ``format`` argument passed into each call to ``String.init(format:_:)``:

.. code-block:: ql

    import swift

    from CallExpr call, Method method
    where
      call.getStaticTarget() = method and
      method.hasQualifiedName("String", "init(format:_:)")
    select call.getArgument(0).getExpr()

Unfortunately this will only give the expression in the argument, not the values which could be passed to it.
So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

    import swift
    import codeql.swift.dataflow.DataFlow

    from CallExpr call, Method method, Expr sourceExpr, Expr sinkExpr
    where
      call.getStaticTarget() = method and
      method.hasQualifiedName("String", "init(format:_:)") and
      sinkExpr = call.getArgument(0).getExpr() and
      DataFlow::localFlow(DataFlow::exprNode(sourceExpr), DataFlow::exprNode(sinkExpr))
    select sourceExpr, sinkExpr

We can vary the source, for example, making the source the parameter of a function rather than an expression. The following query finds where a parameter is used for the format:

.. code-block:: ql

    import swift
    import codeql.swift.dataflow.DataFlow

    from CallExpr call, Method method, ParamDecl sourceParam, Expr sinkExpr
    where
      call.getStaticTarget() = method and
      method.hasQualifiedName("String", "init(format:_:)") and
      sinkExpr = call.getArgument(0).getExpr() and
      DataFlow::localFlow(DataFlow::parameterNode(sourceParam), DataFlow::exprNode(sinkExpr))
    select sourceParam, sinkExpr

The following example finds calls to ``String.init(format:_:)`` where the format string is not a hard-coded string literal:

.. code-block:: ql

    import swift
    import codeql.swift.dataflow.DataFlow

    from CallExpr call, Method method, DataFlow::Node sinkNode
    where
      call.getStaticTarget() = method and
      method.hasQualifiedName("String", "init(format:_:)") and
      sinkNode.asExpr() = call.getArgument(0).getExpr() and
      not exists(StringLiteralExpr sourceLiteral |
        DataFlow::localFlow(DataFlow::exprNode(sourceLiteral), sinkNode)
      )
    select call, "Format argument to " + method.getName() + " isn't hard-coded."

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow.
However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

You can use the global data flow library by implementing the module ``DataFlow::ConfigSig``:

.. code-block:: ql

   import codeql.swift.dataflow.DataFlow

   module MyDataFlowConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       ...
     }

     predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

   module MyDataFlow = DataFlow::Global<MyDataFlowConfiguration>;

These predicates are defined in the configuration:

-  ``isSource`` - defines where data may flow from.
-  ``isSink`` - defines where data may flow to.
-  ``isBarrier`` - optionally, restricts the data flow.
-  ``isAdditionalFlowStep`` - optionally, adds additional flow steps.

The last line (``module MyDataFlow = ...``) instantiates the parameterized module for data flow analysis by passing the configuration to the parameterized module. Data flow analysis can then be performed using ``MyDataFlow::flow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from DataFlow::Node source, DataFlow::Node sink
   where MyDataFlow::flow(source, sink)
   select source, "Dataflow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow what local taint tracking is to local data flow.
That is, global taint tracking extends global data flow with additional non-value-preserving steps.
The global taint tracking library uses the same configuration module as the global data flow library. You can perform taint flow analysis using ``TaintTracking::Global``:

.. code-block:: ql

   module MyTaintFlow = TaintTracking::Global<MyDataFlowConfiguration>;

   from DataFlow::Node source, DataFlow::Node sink
   where MyTaintFlow::flow(source, sink)
   select source, "Taint flow to $@.", sink, sink.toString()

Predefined sources
~~~~~~~~~~~~~~~~~~

The data flow library module ``codeql.swift.dataflow.FlowSources`` contains a number of predefined sources that you can use to write security queries to track data flow and taint flow.

-  The class ``RemoteFlowSource`` represents data flow from remote network inputs and from other applications.
-  The class ``LocalFlowSource`` represents data flow from local user input.
-  The class ``FlowSource`` includes both of the above.

Examples of global data flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following global taint-tracking query finds places where a string literal is used in a function call argument named "password".
  - Since this is a taint-tracking query, the ``TaintTracking::Global`` module is used.
  - The ``isSource`` predicate defines sources as any ``StringLiteralExpr``.
  - The ``isSink`` predicate defines sinks as arguments to a ``CallExpr`` called "password".
  - The sources and sinks may need tuning to a particular use, for example, if passwords are represented by a type other than ``String`` or passed in arguments of a different name than "password".

.. code-block:: ql

   import swift
   import codeql.swift.dataflow.DataFlow
   import codeql.swift.dataflow.TaintTracking

   module ConstantPasswordConfig implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node node) { node.asExpr() instanceof StringLiteralExpr }

     predicate isSink(DataFlow::Node node) {
       // any argument called `password`
       exists(CallExpr call | call.getArgumentWithLabel("password").getExpr() = node.asExpr())
     }

   module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;

   from DataFlow::Node sourceNode, DataFlow::Node sinkNode
   where ConstantPasswordFlow::flow(sourceNode, sinkNode)
   select sinkNode, "The value $@ is used as a constant password.", sourceNode, sourceNode.toString()


The following global taint-tracking query finds places where a value from a remote or local user input is used as an argument to the SQLite ``Connection.execute(_:)`` function.
  - Since this is a taint-tracking query, the ``TaintTracking::Global`` module is used.
  - The ``isSource`` predicate defines sources as a ``FlowSource`` (remote or local user input).
  - The ``isSink`` predicate defines sinks as the first argument in any call to ``Connection.execute(_:)``.

.. code-block:: ql

   import swift
   import codeql.swift.dataflow.DataFlow
   import codeql.swift.dataflow.TaintTracking
   import codeql.swift.dataflow.FlowSources

   module SqlInjectionConfig implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

     predicate isSink(DataFlow::Node node) {
       exists(CallExpr call |
         call.getStaticTarget().(Method).hasQualifiedName("Connection", "execute(_:)") and
         call.getArgument(0).getExpr() = node.asExpr()
       )
     }
   }

   module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

   from DataFlow::Node sourceNode, DataFlow::Node sinkNode
   where SqlInjectionFlow::flow(sourceNode, sinkNode)
   select sinkNode, "This query depends on a $@.", sourceNode, "user-provided value"

Further reading
---------------

- `Exploring data flow with path queries  <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/exploring-data-flow-with-path-queries>`__ in the GitHub documentation.


.. include:: ../reusables/swift-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
