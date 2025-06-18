.. _analyzing-data-flow-in-rust:

Analyzing data flow in Rust
=============================

You can use CodeQL to track the flow of data through a Rust program to places where the data is used.

About this article
------------------

This article describes how data flow analysis is implemented in the CodeQL libraries for Rust and includes examples to help you write your own data flow queries.
The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.
For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

.. include:: ../reusables/new-data-flow-api.rst

Local data flow
---------------

Local data flow tracks the flow of data within a single method or callable. Local data flow is easier, faster, and more precise than global data flow. Before looking at more complex tracking, you should always consider local tracking because it is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

You can use the local data flow library by importing the ``codeql.rust.dataflow.DataFlow`` module. The library uses the class ``Node`` to represent any element through which data can flow.
Common ``Node`` types include expression nodes (``ExprNode``) and parameter nodes (``ParameterNode``).
You can use the ``asExpr`` member predicate to map a data flow ``ExprNode`` to its corresponding ``ExprCfgNode`` in the control-flow library.
Similarly, you can map a data flow ``ParameterNode`` to its corresponding ``Parameter`` AST node using the ``asParameter`` member predicate.
.. code-block:: ql

     class Node {
       /** Gets the expression corresponding to this node, if any. */
       CfgNodes::ExprCfgNode asExpr() { ... }

       /** Gets the parameter corresponding to this node, if any. */
       Parameter asParameter() { ... }

      ...
     }

Note that since ``asExpr`` maps from data-flow to control-flow nodes, you then need to call the ``getExpr`` member predicate on the control-flow node to map to the corresponding AST node,
for example by writing ``node.asExpr().getExpr()``.
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

.. code-block:: rust

     let y: String = "Hello ".to_owned() + x

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

This query finds the argument passed in each call to ``File::create``:

.. code-block:: ql

    import rust

    from CallExpr call
    where call.getStaticTarget().(Function).getCanonicalPath() = "<std::fs::File>::create"
    select call.getArg(0)

Unfortunately this will only give the expression in the argument, not the values which could be passed to it.
So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

    import rust
    import codeql.rust.dataflow.DataFlow

    from CallExpr call, DataFlow::ExprNode source, DataFlow::ExprNode sink
    where
      call.getStaticTarget().(Function).getCanonicalPath() = "<std::fs::File>::create" and
      sink.asExpr().getExpr() = call.getArg(0) and
      DataFlow::localFlow(source, sink)
    select source, sink

We can vary the source, for example, making the source the parameter of a function rather than an expression. The following query finds where a parameter is used for the file creation:

.. code-block:: ql

    import rust
    import codeql.rust.dataflow.DataFlow

    from CallExpr call, DataFlow::ParameterNode source, DataFlow::ExprNode sink
    where
      call.getStaticTarget().(Function).getCanonicalPath() = "<std::fs::File>::create" and
      sink.asExpr().getExpr() = call.getArg(0) and
      DataFlow::localFlow(source, sink)
    select source, sink

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow.
However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

We can use the global data flow library by implementing the signature ``DataFlow::ConfigSig`` and applying the module ``DataFlow::Global<ConfigSig>``:

.. code-block:: ql

   import codeql.rust.dataflow.DataFlow

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
-  ``isBarrier`` - optional, defines where data flow is blocked.
-  ``isAdditionalFlowStep`` - optional, adds additional flow steps.

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

The library module ``codeql.rust.Concepts`` contains a number of predefined sources and sinks that you can use to write security queries to track data flow and taint flow.

Examples of global data flow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following global taint-tracking query finds places where a string literal is used in a function call argument named "password".
  - Since this is a taint-tracking query, the ``TaintTracking::Global`` module is used.
  - The ``isSource`` predicate defines sources as any ``StringLiteralExpr``.
  - The ``isSink`` predicate defines sinks as arguments to a ``CallExpr`` called "password".
  - The sources and sinks may need tuning to a particular use, for example, if passwords are represented by a type other than ``String`` or passed in arguments of a different name than "password".

.. code-block:: ql

    import rust
    import codeql.rust.dataflow.DataFlow
    import codeql.rust.dataflow.TaintTracking

    module ConstantPasswordConfig implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node node) { node.asExpr().getExpr() instanceof StringLiteralExpr }

      predicate isSink(DataFlow::Node node) {
        // any argument going to a parameter called `password`
        exists(Function f, CallExpr call, int index |
          call.getArg(index) = node.asExpr().getExpr() and
          call.getStaticTarget() = f and
          f.getParam(index).getPat().(IdentPat).getName().getText() = "password"
        )
      }
    }

    module ConstantPasswordFlow = TaintTracking::Global<ConstantPasswordConfig>;

    from DataFlow::Node sourceNode, DataFlow::Node sinkNode
    where ConstantPasswordFlow::flow(sourceNode, sinkNode)
    select sinkNode, "The value $@ is used as a constant password.", sourceNode, sourceNode.toString()


Further reading
---------------

- `Exploring data flow with path queries  <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/exploring-data-flow-with-path-queries>`__ in the GitHub documentation.


.. include:: ../reusables/rust-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
