.. _analyzing-data-flow-in-cpp:

.. pull-quote:: Note

   The data flow library used in this article has been replaced with an improved library which is available from CodeQL 2.12.5 onwards, see :ref:`Analyzing data flow in C and C++ (new) <analyzing-data-flow-in-cpp-new>`. The old library has been deprecated in CodeQL 2.14.1 and will be removed in a later release. With the release of CodeQL 2.13.0 both libraries use the new modular API for data flow.

Analyzing data flow in C and C++
================================

You can use data flow analysis to track the flow of potentially malicious or insecure data that can cause vulnerabilities in your codebase.

About data flow
---------------

Data flow analysis computes the possible values that a variable can hold at various points in a program, determining how those values propagate through the program, and where they are used. In CodeQL, you can model both local data flow and global data flow. For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

Local data flow
---------------

Local data flow is data flow within a single function. Local data flow is usually easier, faster, and more precise than global data flow, and is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

The local data flow library is in the module ``DataFlow``, which defines the class ``Node`` denoting any element that data can flow through. ``Node``\ s are divided into expression nodes (``ExprNode``) and parameter nodes (``ParameterNode``). It is possible to map between data flow nodes and expressions/parameters using the member predicates ``asExpr`` and ``asParameter``:

.. code-block:: ql

   class Node {
     /** Gets the expression corresponding to this node, if any. */
     Expr asExpr() { ... }

     /** Gets the parameter corresponding to this node, if any. */
     Parameter asParameter() { ... }

     ...
   }

or using the predicates ``exprNode`` and ``parameterNode``:

.. code-block:: ql

   /**
    * Gets the node corresponding to expression `e`.
    */
   ExprNode exprNode(Expr e) { ... }

   /**
    * Gets the node corresponding to the value of parameter `p` at function entry.
    */
   ParameterNode parameterNode(Parameter p) { ... }

The predicate ``localFlowStep(Node nodeFrom, Node nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``. The predicate can be applied recursively (using the ``+`` and ``*`` operators), or through the predefined recursive predicate ``localFlow``, which is equivalent to ``localFlowStep*``.

For example, finding flow from a parameter ``source`` to an expression ``sink`` in zero or more local steps can be achieved as follows:

.. code-block:: ql

   DataFlow::localFlow(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

.. code-block:: cpp

   int i = tainted_user_input();
   some_big_struct *array = malloc(i * sizeof(some_big_struct));

In this case, the argument to ``malloc`` is tainted.

The local taint tracking library is in the module ``TaintTracking``. Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``. The predicate can be applied recursively (using the ``+`` and ``*`` operators), or through the predefined recursive predicate ``localTaint``, which is equivalent to ``localTaintStep*``.

For example, finding taint propagation from a parameter ``source`` to an expression ``sink`` in zero or more local steps can be achieved as follows:

.. code-block:: ql

   TaintTracking::localTaint(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Examples
~~~~~~~~

The following query finds the filename passed to ``fopen``.

.. code-block:: ql

   import cpp

   from Function fopen, FunctionCall fc
   where fopen.hasGlobalName("fopen")
     and fc.getTarget() = fopen
   select fc.getArgument(0)

Unfortunately, this will only give the expression in the argument, not the values which could be passed to it. So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.DataFlow

   from Function fopen, FunctionCall fc, Expr src
   where fopen.hasGlobalName("fopen")
     and fc.getTarget() = fopen
     and DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(fc.getArgument(0)))
   select src

Then we can vary the source and, for example, use the parameter of a function. The following query finds where a parameter is used when opening a file:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.DataFlow

   from Function fopen, FunctionCall fc, Parameter p
   where fopen.hasGlobalName("fopen")
     and fc.getTarget() = fopen
     and DataFlow::localFlow(DataFlow::parameterNode(p), DataFlow::exprNode(fc.getArgument(0)))
   select p

The following example finds calls to formatting functions where the format string is not hard-coded.

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow
   import semmle.code.cpp.commons.Printf

   from FormattingFunction format, FunctionCall call, Expr formatString
   where call.getTarget() = format
     and call.getArgument(format.getFormatParameterIndex()) = formatString
     and not exists(DataFlow::Node source, DataFlow::Node sink |
       DataFlow::localFlow(source, sink) and
       source.asExpr() instanceof StringLiteral and
       sink.asExpr() = formatString
     )
   select call, "Argument to " + format.getQualifiedName() + " isn't hard-coded."

Exercises
~~~~~~~~~

Exercise 1: Write a query that finds all hard-coded strings used to create a ``host_ent`` via ``gethostbyname``, using local data flow. (`Answer <#exercise-1>`__)

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

The global data flow library is used by implementing the signature ``DataFlow::ConfigSig`` and applying the module ``DataFlow::Global<ConfigSig>`` as follows:

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow

   module MyFlowConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       ...
     }

     predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

   module MyFlow = DataFlow::Global<MyFlowConfiguration>;


The following predicates are defined in the configuration:

-  ``isSource``—defines where data may flow from
-  ``isSink``—defines where data may flow to
-  ``isBarrier``—optional, restricts the data flow
-  ``isAdditionalFlowStep``—optional, adds additional flow steps

The data flow analysis is performed using the predicate ``flow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from DataFlow::Node source, DataFlow::Node sink
   where MyFlow::flow(source, sink)
   select source, "Data flow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow as local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. The global taint tracking library is used by applying the module ``TaintTracking::Global<ConfigSig>`` to your configuration instead of ``DataFlow::Global<ConfigSig>`` as follows:

.. code-block:: ql

   import semmle.code.cpp.dataflow.TaintTracking

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

Examples
~~~~~~~~

The following data flow configuration tracks data flow from environment variables to opening files in a Unix-like environment:

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow

   module EnvironmentToFileConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       exists (Function getenv |
         source.asExpr().(FunctionCall).getTarget() = getenv and
         getenv.hasGlobalName("getenv")
       )
     }

     predicate isSink(DataFlow::Node sink) {
       exists (FunctionCall fc |
         sink.asExpr() = fc.getArgument(0) and
         fc.getTarget().hasGlobalName("fopen")
       )
     }
   }

   module EnvironmentToFileFlow = DataFlow::Global<EnvironmentToFileConfiguration>;

   from Expr getenv, Expr fopen
   where EnvironmentToFileFlow::flow(DataFlow::exprNode(getenv), DataFlow::exprNode(fopen))
   select fopen, "This 'fopen' uses data from $@.",
     getenv, "call to 'getenv'"

The following taint-tracking configuration tracks data from a call to ``ntohl`` to an array index operation. It uses the ``Guards`` library to recognize expressions that have been bounds-checked, and defines ``isBarrier`` to prevent taint from propagating through them. It also uses ``isAdditionalFlowStep`` to add flow from loop bounds to loop indexes.

.. code-block:: ql

  import cpp
  import semmle.code.cpp.controlflow.Guards
  import semmle.code.cpp.dataflow.TaintTracking

  module NetworkToBufferSizeConfiguration implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node node) {
      node.asExpr().(FunctionCall).getTarget().hasGlobalName("ntohl")
    }

    predicate isSink(DataFlow::Node node) {
      exists(ArrayExpr ae | node.asExpr() = ae.getArrayOffset())
    }

    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Loop loop, LoopCounter lc |
        loop = lc.getALoop() and
        loop.getControllingExpr().(RelationalOperation).getGreaterOperand() = pred.asExpr() |
        succ.asExpr() = lc.getVariableAccessInLoop(loop)
      )
    }

    predicate isBarrier(DataFlow::Node node) {
      exists(GuardCondition gc, Variable v |
        gc.getAChild*() = v.getAnAccess() and
        node.asExpr() = v.getAnAccess() and
        gc.controls(node.asExpr().getBasicBlock(), _)
      )
    }
  }

  module NetworkToBufferSizeFlow = TaintTracking::Global<NetworkToBufferSizeConfiguration>;

  from DataFlow::Node ntohl, DataFlow::Node offset
  where NetworkToBufferSizeFlow::flow(ntohl, offset)
  select offset, "This array offset may be influenced by $@.", ntohl,
    "converted data from the network"



Exercises
~~~~~~~~~

Exercise 2: Write a query that finds all hard-coded strings used to create a ``host_ent`` via ``gethostbyname``, using global data flow. (`Answer <#exercise-2>`__)

Exercise 3: Write a class that represents flow sources from ``getenv``. (`Answer <#exercise-3>`__)

Exercise 4: Using the answers from 2 and 3, write a query which finds all global data flows from ``getenv`` to ``gethostbyname``. (`Answer <#exercise-4>`__)

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow

   from StringLiteral sl, FunctionCall fc
   where fc.getTarget().hasName("gethostbyname")
     and DataFlow::localFlow(DataFlow::exprNode(sl), DataFlow::exprNode(fc.getArgument(0)))
   select sl, fc

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow

   module LiteralToGethostbynameConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       source.asExpr() instanceof StringLiteral
     }

     predicate isSink(DataFlow::Node sink) {
       exists (FunctionCall fc |
         sink.asExpr() = fc.getArgument(0) and
         fc.getTarget().hasName("gethostbyname"))
     }
   }

   module LiteralToGethostbynameFlow = DataFlow::Global<LiteralToGethostbynameConfiguration>;

   from StringLiteral sl, FunctionCall fc
   where LiteralToGethostbynameFlow::flow(DataFlow::exprNode(sl), DataFlow::exprNode(fc.getArgument(0)))
   select sl, fc

Exercise 3
~~~~~~~~~~

.. code-block:: ql

   import cpp

   class GetenvSource extends FunctionCall {
     GetenvSource() {
       this.getTarget().hasGlobalName("getenv")
     }
   }

Exercise 4
~~~~~~~~~~

.. code-block:: ql

   import semmle.code.cpp.dataflow.DataFlow

   class GetenvSource extends DataFlow::Node {
     GetenvSource() {
       this.asExpr().(FunctionCall).getTarget().hasGlobalName("getenv")
     }
   }

   module GetenvToGethostbynameConfiguration implements DataFlow::ConfigSig {
     predicate isSource(DataFlow::Node source) {
       source instanceof GetenvSource
     }

     predicate isSink(DataFlow::Node sink) {
       exists (FunctionCall fc |
         sink.asExpr() = fc.getArgument(0) and
         fc.getTarget().hasName("gethostbyname"))
     }
   }

   module GetenvToGethostbynameFlow = DataFlow::Global<GetenvToGethostbynameConfiguration>;

   from DataFlow::Node getenv, FunctionCall fc
   where GetenvToGethostbynameFlow::flow(getenv, DataFlow::exprNode(fc.getArgument(0)))
   select getenv.asExpr(), fc

Further reading
---------------

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"


.. include:: ../reusables/cpp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
